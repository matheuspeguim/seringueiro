import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './property_settings_event.dart';
import './property_settings_state.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';

class PropertySettingsBloc
    extends Bloc<PropertySettingsEvent, PropertySettingsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PropertySettingsBloc() : super(PropertySettingsInitial()) {
    on<LoadPropertySettings>(_onLoadPropertySettings);
    on<ManageUsers>(_onManageUsers);
    on<UpdateUserPermissions>(_onUpdateUserPermissions);
    on<LeaveProperty>(_onLeaveProperty);
    on<DeleteProperty>(_onDeleteProperty);
  }

  Future<PropertyUser?> _getUserPermissions(String propertyId) async {
    final uid = _auth.currentUser?.uid ?? '';
    final propertyUsersDoc = await _firestore
        .collection('property_users')
        .where('propertyId', isEqualTo: propertyId)
        .where('uid', isEqualTo: uid)
        .get();

    if (propertyUsersDoc.docs.isNotEmpty) {
      return PropertyUser.fromFirestore(propertyUsersDoc.docs.first);
    }
    return null;
  }

  Future<List<PropertyUser>> _getPropertyUsers(String propertyId) async {
    final allUsersDocs = await _firestore
        .collection('property_users')
        .where('propertyId', isEqualTo: propertyId)
        .get();
    return allUsersDocs.docs
        .map((doc) => PropertyUser.fromFirestore(doc))
        .toList();
  }

  void _onLoadPropertySettings(
      LoadPropertySettings event, Emitter<PropertySettingsState> emit) async {
    emit(PropertySettingsLoading());
    try {
      final propertyUser = await _getUserPermissions(event.propertyId);
      if (propertyUser != null && propertyUser.administrador) {
        final users = await _getPropertyUsers(event.propertyId);
        emit(PropertySettingsAdmin(users, event.propertyId));
      } else if (propertyUser != null) {
        emit(PropertySettingsUser(event.propertyId));
      } else {
        emit(PropertySettingsError("Usuário não encontrado na propriedade."));
      }
    } catch (e) {
      emit(PropertySettingsError(
          "Erro ao carregar configurações da propriedade. Detalhes: ${e.toString()}"));
    }
  }

  void _onManageUsers(
      ManageUsers event, Emitter<PropertySettingsState> emit) async {
    // A lógica aqui permanece essencialmente a mesma que a original, mas com a lógica de acesso a dados já isolada
  }

  void _onUpdateUserPermissions(
      UpdateUserPermissions event, Emitter<PropertySettingsState> emit) async {
    // Atualize as permissões do usuário aqui
  }

  void _onLeaveProperty(
      LeaveProperty event, Emitter<PropertySettingsState> emit) async {
    emit(
        PropertySettingsLoading()); // Opcional: Indica que uma ação está em progresso

    try {
      // Obter a instância atual do Firestore e o ID do usuário atual
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Buscar o documento que corresponde ao userId e propertyId
      final QuerySnapshot propertyUserSnapshot = await firestore
          .collection('property_users')
          .where('propertyId', isEqualTo: event.propertyId)
          .where('uid',
              isEqualTo:
                  event.userId) // Assumindo que você passou userId no evento
          .limit(
              1) // Assumindo que só existe um documento por usuário por propriedade
          .get();

      // Se um documento é encontrado, procede com a exclusão
      if (propertyUserSnapshot.docs.isNotEmpty) {
        await firestore
            .collection('property_users')
            .doc(propertyUserSnapshot.docs.first.id)
            .delete();
        emit(
            PropertySettingsLeftProperty()); // Indica que o usuário saiu da propriedade com sucesso
      } else {
        // Caso nenhum documento seja encontrado (o que seria inesperado)
        emit(PropertySettingsError(
            "Não foi possível encontrar o usuário na propriedade."));
      }
    } catch (e) {
      // Trata qualquer erro que possa ocorrer durante a busca ou exclusão
      emit(PropertySettingsError(
          "Erro ao tentar sair da propriedade: ${e.toString()}"));
    }
  }

  void _onDeleteProperty(
      DeleteProperty event, Emitter<PropertySettingsState> emit) async {
    // Implemente a lógica para deletar a propriedade
  }
}
