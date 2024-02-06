import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth;
  Timer? _emailVerificationTimer;

  SignUpBloc(this._auth) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    // ... outros event handlers
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading()); // Emitir estado de carregamento

    try {
      // Tenta criar um novo usuário com e-mail e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification(); // Enviar e-mail de verificação
          _startEmailVerificationCheck(user, emit);
        } else {
          emit(SignUpSuccess(
              user:
                  user)); // Emitir estado de sucesso caso o usuário já esteja verificado
        }
      } else {
        emit(SignUpFailure('Usuário não encontrado após o registro.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignUpFailure(
          e.code)); // Emitir estado de falha com a mensagem de erro
    } catch (e) {
      emit(SignUpFailure(
          e.toString())); // Emitir estado de falha com a mensagem de erro
    }
  }

  void _startEmailVerificationCheck(User user, Emitter<SignUpState> emit) {
    emit(EmailVerificationInProgress());

    _emailVerificationTimer?.cancel(); // Cancela o timer anterior se existir
    _emailVerificationTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      await user.reload();
      User? currentUser = _auth.currentUser;

      if (currentUser != null && currentUser.emailVerified) {
        timer.cancel();
        emit(EmailVerificationDone());
        // Aqui você pode redirecionar para outra página ou realizar outra ação
      }
    });
  }

  @override
  Future<void> close() {
    _emailVerificationTimer
        ?.cancel(); // Garante que o timer seja cancelado quando o Bloc for fechado
    return super.close();
  }
}
