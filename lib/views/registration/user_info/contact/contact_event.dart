import 'package:firebase_auth/firebase_auth.dart';

abstract class ContactEvent {}

class ContactInfoSubmitted extends ContactEvent {
  final User user;
  final String celular;

  ContactInfoSubmitted({
    required this.user,
    required this.celular,
  });
}
