// email_verification_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<SendVerificationEmail>(_onSendVerificationEmail);
    on<CheckEmailVerified>(_onCheckEmailVerified);
  }

  Future<void> _onSendVerificationEmail(
      SendVerificationEmail event, Emitter<EmailVerificationState> emit) async {
    emit(EmailVerificationLoading());
    try {
      // Aqui você chamaria o método para enviar o e-mail de verificação do FirebaseAuth
      emit(EmailVerificationSent());
    } catch (e) {
      emit(EmailVerificationFailed(e.toString()));
    }
  }

  Future<void> _onCheckEmailVerified(
      CheckEmailVerified event, Emitter<EmailVerificationState> emit) async {
    // Aqui você implementaria a lógica para verificar se o usuário verificou seu e-mail
  }
}
