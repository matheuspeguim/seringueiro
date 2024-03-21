import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_event.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc() : super(UserSearchInitial()) {
    on<UserSearchCleared>((event, emit) {
      emit(UserSearchEmpty());
    });
    on<UserSearchQueryChanged>((event, emit) async {
      if (event.query.isEmpty) {
        // Opção para emitir um estado vazio ou inicial
        emit(UserSearchEmpty());
        return;
      }

      emit(UserSearchLoading());
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('idPersonalizado', isGreaterThanOrEqualTo: event.query)
            .where('idPersonalizado',
                isLessThan:
                    event.query + '\uf8ff') // Para limitar a busca ao prefixo
            .get();

        final users = querySnapshot.docs
            .map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        if (users.isEmpty) {
          emit(
              UserSearchEmpty()); // Emitir estado vazio se não houver resultados
        } else {
          emit(UserSearchSuccess(users));
        }
      } catch (error) {
        emit(UserSearchError("Não foi possível buscar usuários."));
      }
    });

    // Adicione os demais manipuladores de eventos conforme necessário
  }
}
