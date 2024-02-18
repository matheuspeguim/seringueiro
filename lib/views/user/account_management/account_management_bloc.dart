import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_event.dart';
import 'package:flutter_seringueiro/views/user/account_management/account_management_state.dart';

class AccountManagementBloc
    extends Bloc<AccountManagementEvent, AccountManagementState> {
  AccountManagementBloc() : super(AccountManagementInitial()) {
    on<ProfileImageSubmitted>(_onProfileImageSubmitted);
    on<PersonalDataSubmitted>(_onPersonalDataSubmitted);
    on<ContactDataSubmitted>(_onContactDataSubmitted);
    on<AdressDataSubmitted>(_onAdressDataSubmitted);
  }

  Future<void> _onProfileImageSubmitted(ProfileImageSubmitted event,
      Emitter<AccountManagementState> emit) async {}

  Future<void> _onPersonalDataSubmitted(PersonalDataSubmitted event,
      Emitter<AccountManagementState> emit) async {}

  Future<void> _onContactDataSubmitted(
      ContactDataSubmitted event, Emitter<AccountManagementState> emit) async {}
}

Future<void> _onAdressDataSubmitted(
    AdressDataSubmitted event, Emitter<AccountManagementState> emit) async {}
