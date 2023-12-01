import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_event.dart';
import 'personal_state.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  PersonalBloc() : super(PersonalInitial()) {
    on<PersonalInfoSubmitted>(_onPersonalInfoSubmitted);
  }

  void _onPersonalInfoSubmitted(
      PersonalInfoSubmitted event, Emitter<PersonalState> emit) async {
    try {
      emit(PersonalLoading());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.user.uid)
          .collection('personal_info')
          .doc('info')
          .set({
        'nome': event.nome,
        'dataDeNascimento': event.dataDeNascimento.toIso8601String(),
        'cpf': event.cpf,
        'rg': event.rg,
      });
      emit(PersonalInfoSuccess());
    } catch (e) {
      emit(PersonalFailure(e.toString()));
      emit(PersonalInitial());
    }
  }
}
