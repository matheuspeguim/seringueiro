// user_search_event.dart
abstract class UserSearchEvent {}

class UserSearchQueryChanged extends UserSearchEvent {
  final String query;

  UserSearchQueryChanged(this.query);
}

class UserSearchCleared extends UserSearchEvent {}

class UserSelected extends UserSearchEvent {
  final String userId;

  UserSelected(this.userId);
}

class PropertySelectedForUser extends UserSearchEvent {
  final String propertyId;
  final String userId;

  PropertySelectedForUser(this.userId, this.propertyId);
}
