import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<ContactInfoSubmitted>(_onContactInfoSubmitted);
  }

  void _onContactInfoSubmitted(
      ContactInfoSubmitted event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      // Lógica para salvar informações de contato no Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.user.uid)
          .collection('contact_info')
          .doc('info')
          .set({
        'celular': event.celular,
      });
      emit(ContactInfoSuccess());
    } catch (e) {
      emit(ContactFailure(error: e.toString()));
    }
  }
}
