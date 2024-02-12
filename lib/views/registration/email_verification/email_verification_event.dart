// email_verification_event.dart

abstract class EmailVerificationEvent {}

class SendVerificationEmail extends EmailVerificationEvent {}

class CheckEmailVerified extends EmailVerificationEvent {}
