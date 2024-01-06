import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String? profilePictureUrl;

      // Fazer o upload da imagem, se existir
      if (event.imageFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String filePath = 'profilePictures/${event.user.uid}';
        TaskSnapshot snapshot =
            await storage.ref(filePath).putFile(File(event.imageFile!.path));
        profilePictureUrl = await snapshot.ref.getDownloadURL();
      }

      // Salvar os dados do usuário no Firestore, incluindo a URL da imagem
      await firestore.collection('users').doc(event.user.uid).set({
        'nome': event.nome,
        'dataDeNascimento': event.dataDeNascimento.toIso8601String(),
        'cpf': event.cpf,
        'rg': event.rg,
        'idPersonalizado': event.idPersonalizado,
        if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
      }, SetOptions(merge: true));

      emit(PersonalInfoSuccess());
    } catch (e) {
      emit(PersonalFailure(e.toString()));
    }
  }
}
