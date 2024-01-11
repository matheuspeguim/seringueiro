abstract class PropertyUsersEvent {}

class FetchPropertyUsers extends PropertyUsersEvent {
  final String propertyId;

  FetchPropertyUsers(this.propertyId);
}
