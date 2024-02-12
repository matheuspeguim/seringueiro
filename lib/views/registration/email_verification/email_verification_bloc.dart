// email_verification_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<EmailVerificationEvent>((event, emit) {});
    on<SendVerificationEmail>(_onSendVerificationEmail);
    on<CheckEmailVerified>(_onCheckEmailVerified);

    _sendVerificationEmail(); // Chama automaticamente ao inicializar o Bloc
  }

  void _sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      print('E-mail de verificacao solicitado!');
      await user.sendEmailVerification();
      add(SendVerificationEmail());
    }
  }

  Future<void> _onSendVerificationEmail(
      SendVerificationEmail event, Emitter<EmailVerificationState> emit) async {
    emit(EmailVerificationSent());
  }

// Ajuste na função _onCheckEmailVerified

  Future<void> _onCheckEmailVerified(
      CheckEmailVerified event, Emitter<EmailVerificationState> emit) async {
    final user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      emit(EmailVerified(user)); // Passa o usuário verificado
    } else {
      emit(EmailVerificationFailed(
          'O e-mail ainda não foi verificado. Por favor, verifique seu e-mail.'));
    }
  }
}
