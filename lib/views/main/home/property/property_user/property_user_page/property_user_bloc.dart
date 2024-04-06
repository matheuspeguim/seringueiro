import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_state.dart';

// Inclua os imports necessários

class PropertyUserBloc extends Bloc<PropertyUserEvent, PropertyUserState> {
  PropertyUserBloc() : super(PropertyUserInitial()) {
    on<LoadPropertyUserDetails>(_onLoadPropertyUserDetails);
    on<UpdateUserRoles>(_onUpdateUserRoles);
    on<ConfirmPropertyUser>(_onConfirmPropertyUser);
    on<DeletePropertyUser>(_onDeletePropertyUser);
  }

  Future<void> _onLoadPropertyUserDetails(
      LoadPropertyUserDetails event, Emitter<PropertyUserState> emit) async {
    emit(PropertyUserLoading());
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('property_users')
          .doc(event.propertyUserId)
          .get();

      if (!docSnapshot.exists) {
        emit(PropertyUserError("PropertyUser não encontrado."));
        return;
      }

      // Assumindo que a classe PropertyUser tem um método fromFirestore que retorna uma Future<PropertyUser>
      PropertyUser propertyUser = await PropertyUser.fromFirestore(docSnapshot);

      emit(PropertyUserLoaded(propertyUser: propertyUser));
    } catch (e) {
      emit(PropertyUserError(
          "Erro ao carregar detalhes do usuário: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateUserRoles(
      UpdateUserRoles event, Emitter<PropertyUserState> emit) async {
    // Implemente a lógica para atualizar as funções do usuário
    // Lembre-se de emitir um estado após a conclusão
  }

  Future<void> _onConfirmPropertyUser(
      ConfirmPropertyUser event, Emitter<PropertyUserState> emit) async {
    // Implemente a lógica para confirmar o PropertyUser
    // Emita o estado adequado após a confirmação
  }

  Future<void> _onDeletePropertyUser(
      DeletePropertyUser event, Emitter<PropertyUserState> emit) async {
    // Implemente a lógica para excluir o PropertyUser
    // Emita o estado adequado após a exclusão
  }
}
