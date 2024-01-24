// signup_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth;

  SignUpBloc(this._auth) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      // Tente criar um novo usuário com o Firebase Authentication
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.senha,
      );

      // Aqui você pode adicionar mais lógica, como salvar dados do usuário no Firestore

      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseAuthException(e);
      emit(SignUpFailure(errorMessage));
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
}
