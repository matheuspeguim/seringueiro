abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactInfoSuccess extends ContactState {}

class ContactFailure extends ContactState {
  final String error;

  ContactFailure({required this.error});
}
