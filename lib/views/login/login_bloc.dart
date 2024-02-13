// login_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginWithEmailSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginWithEmailSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // Tente autenticar o usuário com Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      if (userCredential.user != null) {
        // Chama o método para verificar as informações do usuário
        await _checkEmailVerification(emit);
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _checkEmailVerification(Emitter<LoginState> emit) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(LoginFailure(
          error:
              'Usuário não foi autenticado!')); // Estado para usuário não autenticado
    } else if (!user.emailVerified) {
      emit(EmailNotVerified(
          user: user)); // Estado específico para e-mail não verificado
    } else {
      emit(LoginSuccess(
          user: user)); // Usuário autenticado com sucesso e e-mail verificado
    }
  }
}
