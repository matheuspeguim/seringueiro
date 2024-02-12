import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    try {
      // Cria a conta no Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      User? user = userCredential.user;
      if (user == null) {
        emit(SignUpFailure('Erro ao criar usuário.'));
        return;
      }

      // Após a criação do usuário, verifica se há duplicidade de dados no Firestore
      bool hasDuplicateData = await _checkForDuplicateData(event, user.uid);
      if (hasDuplicateData) {
        // Se houver dados duplicados, exclui o usuário recém-criado do Auth
        await user.delete();
        emit(SignUpFailure(
            'Já existe um cadastro com o CPF, RG ou ID personalizado fornecido.'));
        return;
      }

      // Verifica se há uma imagem de perfil para upload
      String? profilePictureUrl;
      if (event.imageFile != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('profilePictures/${user.uid}');
        final uploadTask = storageRef.putFile(File(event.imageFile!.path));
        final snapshot = await uploadTask.whenComplete(() => {});
        profilePictureUrl = await snapshot.ref.getDownloadURL();
      }

      // Salva os dados adicionais no Firestore, incluindo a URL da imagem de perfil (se houver)
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': event.email,
        'celular': event.celular,
        'idPersonalizado': event.idPersonalizado,
        'nome': event.nome,
        'nascimento': event.nascimento,
        'cpf': event.cpf,
        'rg': event.rg,
        'cep': event.cep,
        'logradouro': event.logradouro,
        'numero': event.numero,
        'bairro': event.bairro,
        'cidade': event.cidade,
        'estado': event.estado,
        if (profilePictureUrl != null)
          'profilePictureUrl':
              profilePictureUrl, // Adiciona a URL da imagem de perfil condicionalmente
        // Outros campos conforme necessário
      });

      emit(SignUpSuccess(user: user));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<bool> _checkForDuplicateData(
      SignUpSubmitted event, String userId) async {
    // Realiza as verificações de CPF, RG e ID personalizado no Firestore
    // Retorna true se encontrar algum dado duplicado
    List<Future<QuerySnapshot>> queries = [
      FirebaseFirestore.instance
          .collection('users')
          .where('cpf', isEqualTo: event.cpf)
          .get(),
      FirebaseFirestore.instance
          .collection('users')
          .where('rg', isEqualTo: event.rg)
          .get(),
      FirebaseFirestore.instance
          .collection('users')
          .where('idPersonalizado', isEqualTo: event.idPersonalizado)
          .get(),
    ];

    List<QuerySnapshot> results = await Future.wait(queries);
    for (var result in results) {
      if (result.docs.isNotEmpty) {
        return true; // Duplicidade encontrada
      }
    }
    return false; // Nenhuma duplicidade encontrada
  }
}
