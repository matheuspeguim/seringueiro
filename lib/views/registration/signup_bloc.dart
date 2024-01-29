// signup_bloc.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth;
  final ViaCepService viaCepService;
  String _verificationId; // Adicione esta variável

  SignUpBloc(this._auth, this.viaCepService, this._verificationId)
      : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<EmailVerificationSubmitted>(_onEmailVerificationSubmitted);
    on<PersonalInfoSubmitted>(_onPersonalInfoSubmitted);
    on<CelularSubmitted>(_onCelularSubmitted);
    on<ConfirmCelularSubmitted>(_onConfirmCelularSubmitted);
    on<CepInfoSubmitted>(_onCepInfoSubmitted);
    on<EnderecoInfoSubmitted>(_onEnderecoInfoSubmitted);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      if (newUser.user != null) {
        await newUser.user!.sendEmailVerification();
        emit(SignUpEmailVerificationSent());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignUpUserAlreadyExists());
      } else {
        String errorMessage = _handleFirebaseAuthException(e);
        emit(SignUpFailure(errorMessage));
      }
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'A senha fornecida é muito fraca.';
      case 'email-already-in-use':
        return 'Já existe uma conta com o e-mail fornecido.';
      // Adicione mais casos conforme necessário
      default:
        return 'Ocorreu um erro desconhecido.';
    }
  }

  Future<void> _onEmailVerificationSubmitted(
      EmailVerificationSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    const checkInterval = Duration(seconds: 5);
    const timeout = Duration(seconds: 60);
    var startTime = DateTime.now();

    try {
      while (DateTime.now().difference(startTime) < timeout) {
        var user = _auth.currentUser;
        await user!.reload();
        if (user.emailVerified) {
          emit(SignUpEmailVerified());
          return;
        }
        await Future.delayed(checkInterval);
      }
      // Tempo esgotado
      emit(SignUpEmailVerificationTimeout());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<void> _onPersonalInfoSubmitted(
      PersonalInfoSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      // Acesso ao usuário atual
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Salvar informações pessoais no Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'nome': event.nome,
          'idPersonalizado': event.idPersonalizado,
          'dataDeNascimento': event.dataDeNascimento,
          'cpf': event.cpf,
          'rg': event.rg,
        });

        // Emitir sucesso após salvar os dados
        emit(SignUpPersonalInfoSaved());
      } else {
        // Emitir erro se não houver usuário conectado
        emit(SignUpFailure('Nenhum usuário conectado.'));
      }
    } on FirebaseAuthException catch (e) {
      // Tratamento de erro do Firebase
      emit(SignUpFailure('Erro ao salvar dados: ${e.message}'));
    } catch (e) {
      // Tratamento de erros gerais
      emit(SignUpFailure('Erro ao salvar dados: ${e.toString()}'));
    }
  }

  Future<void> _onCelularSubmitted(
      CelularSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: event.celular,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Esta função é chamada automaticamente quando o Firebase
          // auto-verifica o SMS.
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(SignUpFailure(e.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId; // Armazena o verificationId
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Esta função é chamada quando o código não é verificado
          // automaticamente dentro de um determinado tempo.
        },
      );
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<void> _onConfirmCelularSubmitted(
      ConfirmCelularSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId:
              _verificationId, // O verificationId obtido anteriormente
          smsCode: event.codigoConfirmarCelular);

      await _auth.currentUser!.linkWithCredential(credential);
      emit(SignUpCelularVerified());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<void> _onCepInfoSubmitted(
      CepInfoSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final cepUnmasked = event.cep.replaceAll('-', '');
      final endereco = await viaCepService.fetchEnderecoByCep(cepUnmasked);
      emit(EnderecoInfoState(
        isEnderecoInfoValid: true,
        rua: endereco['logradouro'] ?? '',
        bairro: endereco['bairro'] ?? '',
        cidade: endereco['localidade'] ?? '',
        estado: endereco['uf'] ?? '',
        cep: event.cep,
      ));
    } catch (error) {
      emit(EnderecoFailure(error: error.toString()));
    }
  }
}

Future<void> _onEnderecoInfoSubmitted(
    EnderecoInfoSubmitted event, Emitter<SignUpState> emit) async {
  emit(SignUpLoading());

  try {
    // Obter o ID do usuário atual
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(SignUpFailure('Usuário não está logado.'));
      return;
    }

    // Referência do documento do usuário no Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Dados de endereço a serem salvos
    final enderecoData = {
      'cep': event.cep,
      'ruaOuSitio': event.ruaOuSitio,
      'complemento': event.complemento,
      'bairro': event.bairro,
      'numero': event.numero,
      'cidade': event.cidade,
      'estado': event.estado,
    };

    // Adicionar os dados de endereço na subcoleção 'adress_info'
    await userDocRef.collection('adress_info').add(enderecoData);

    // Emitir um estado de sucesso após salvar os dados
    emit(SignUpSuccess());
  } catch (e) {
    emit(SignUpFailure(e.toString()));
  }
}
