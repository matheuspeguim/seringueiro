abstract class PropertyUserEvent {}

class LoadPropertyUserDetails extends PropertyUserEvent {
  final String propertyUserId;

  LoadPropertyUserDetails(this.propertyUserId);
}

class UpdateUserRoles extends PropertyUserEvent {
  final String propertyUserId;
  final Map<String, bool> roles;

  UpdateUserRoles(this.propertyUserId, this.roles);
}

class ConfirmPropertyUser extends PropertyUserEvent {
  final String propertyUserId;

  ConfirmPropertyUser(this.propertyUserId);
}

class DeletePropertyUser extends PropertyUserEvent {
  final String propertyUserId;

  DeletePropertyUser(this.propertyUserId);
}
