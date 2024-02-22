import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_widgets/property_buttons_widget/property_button_event.dart';
import 'property_buttons_bloc.dart';
import 'property_buttons_state.dart';

class PropertyButtonsWidget extends StatelessWidget {
  final User user;
  final String propertyId;

  PropertyButtonsWidget(
      {Key? key, required this.user, required this.propertyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PropertyButtonsBloc(
          context: context, firestore: FirebaseFirestore.instance)
        ..add(LoadPropertyButtons(
            user: user, userId: user.uid, propertyId: propertyId)),
      child: BlocBuilder<PropertyButtonsBloc, PropertyButtonsState>(
        builder: (context, state) {
          if (state is PropertyButtonsLoading) {
            return LinearProgressIndicator();
          } else if (state is PropertyButtonsLoaded) {
            return SingleChildScrollView(
              child: Wrap(
                  direction:
                      Axis.horizontal, // Organiza os filhos horizontalmente
                  spacing: 1.0, // Espaço horizontal entre os botões
                  runSpacing: 10.0, // Espaço vertical entre as linhas
                  alignment: WrapAlignment
                      .start, // Alinha os botões ao início do eixo principal
                  children: state.buttons // Os botões carregados
                  ),
            );
          } else if (state is PropertyButtonsError) {
            return Text('Erro: ${state.message}');
          }

          return SizedBox
              .shrink(); // Estado inicial ou outros estados não tratados
        },
      ),
    );
  }
}
