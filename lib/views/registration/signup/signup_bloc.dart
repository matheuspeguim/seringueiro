import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // Verifica se o e-mail já existe no Firebase Auth
      final List<String> userEmails =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(event.email);
      if (userEmails.isNotEmpty) {
        emit(SignUpFailure('E-mail já está em uso.'));
        return;
      }

      // Verifica se o CPF já existe no Firestore
      final cpfQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('cpf', isEqualTo: event.cpf)
          .get();
      if (cpfQuerySnapshot.docs.isNotEmpty) {
        emit(SignUpFailure('CPF já está cadastrado.'));
        return;
      }

      // Verifica se o RG já existe no Firestore
      final rgQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rg', isEqualTo: event.rg)
          .get();
      if (rgQuerySnapshot.docs.isNotEmpty) {
        emit(SignUpFailure('RG já está cadastrado.'));
        return;
      }

      // Verifica se o ID personalizado já existe no Firestore
      final idPersonalizadoQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('idPersonalizado', isEqualTo: event.idPersonalizado)
          .get();
      if (idPersonalizadoQuerySnapshot.docs.isNotEmpty) {
        emit(SignUpFailure('ID personalizado já está em uso.'));
        return;
      }

      // Se todas as verificações passarem, cria a conta no Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Salva os dados adicionais no Firestore
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
          // Outros campos conforme necessário
        });
        emit(SignUpSuccess(user: user));
      } else {
        emit(SignUpFailure('Erro ao criar usuário.'));
      }
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
