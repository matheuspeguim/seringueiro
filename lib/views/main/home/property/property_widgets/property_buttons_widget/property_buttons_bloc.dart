import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/admin_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/agronomo_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_button_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_buttons_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/propietario_widgets.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/seringueiro_widgets.dart';

class PropertyButtonsBloc
    extends Bloc<PropertyButtonsEvent, PropertyButtonsState> {
  final FirebaseFirestore firestore;
  final BuildContext context;

  PropertyButtonsBloc({required this.firestore, required this.context})
      : super(PropertyButtonsInitial()) {
    on<LoadPropertyButtons>(_onLoadPropertyButtons);
  }

  Future<void> _onLoadPropertyButtons(
    LoadPropertyButtons event,
    Emitter<PropertyButtonsState> emit,
  ) async {
    emit(PropertyButtonsLoading());
    try {
      final querySnapshot = await firestore
          .collection('properties')
          .doc(event.propertyId)
          .collection('property_users')
          .where('uid', isEqualTo: event.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userRoleData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        var buttons = <Widget>[];

        // Obter a propriedade
        DocumentSnapshot propertyDoc = await firestore
            .collection('properties')
            .doc(event.propertyId)
            .get();
        Property property = Property.fromFirestore(propertyDoc);
        User user = event.user;
        FieldActivityManager activityManager = FieldActivityManager();

        // Adicionar botões com base nas funções do usuário
        if (userRoleData['funcoes']['seringueiro'] == true) {
          buttons.addAll(SeringueiroWidgets.buildSeringueiroWidgets(
              context, user, property, activityManager));
        }
        if (userRoleData['funcoes']['agronomo'] == true) {
          buttons.addAll(
              AgronomoWidgets.buildAgronomoWidgets(context, user, property));
        }
        if (userRoleData['funcoes']['proprietario'] == true) {
          buttons
              .addAll(ProprietarioWidgets.buildProprietarioWidgets(property));
        }

        if (userRoleData['funcoes']['admin'] == true) {
          buttons.addAll(AdminWidgets.buildAdminWidgets(context, property));
        }

        emit(PropertyButtonsLoaded(buttons));
      } else {
        emit(PropertyButtonsError(
            'Nenhum papel encontrado para o usuário na propriedade'));
      }
    } catch (e) {
      emit(PropertyButtonsError('Erro ao carregar botões: $e'));
    }
  }
}
