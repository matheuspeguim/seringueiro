abstract class PersonalState {}

class PersonalInitial extends PersonalState {}

class PersonalLoading extends PersonalState {}

class PersonalInfoSuccess extends PersonalState {}

class PersonalFailure extends PersonalState {
  final String error;

  PersonalFailure(this.error);
}
