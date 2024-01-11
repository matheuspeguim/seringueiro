import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/models/usuario.dart';
import 'property_users_event.dart';
import 'property_users_state.dart';

class PropertyUsersBloc extends Bloc<PropertyUsersEvent, PropertyUsersState> {
  PropertyUsersBloc() : super(PropertyUsersInitial()) {
    on<FetchPropertyUsers>(_onFetchPropertyUsers);
  }

  Future<void> _onFetchPropertyUsers(
      FetchPropertyUsers event, Emitter<PropertyUsersState> emit) async {
    emit(PropertyUsersLoading());
    try {
      final List<Usuario> users = await fetchUsersForProperty(event.propertyId);
      emit(PropertyUsersLoaded(users));
    } catch (error) {
      emit(PropertyUsersError(error.toString()));
    }
  }

  Future<List<Usuario>> fetchUsersForProperty(String propertyId) async {
    List<Usuario> usuarios = [];

    QuerySnapshot propertyUsersSnapshot = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('property_users')
        .get();

    for (var propertyUserDoc in propertyUsersSnapshot.docs) {
      Map<String, dynamic> propertyUserData =
          propertyUserDoc.data() as Map<String, dynamic>;
      String userId = propertyUserData['uid'];

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // Aqui você pode adicionar campos adicionais que você queira passar para o construtor de Usuario
        usuarios.add(Usuario.fromMap(userData));
      }
    }

    return usuarios;
  }
}
