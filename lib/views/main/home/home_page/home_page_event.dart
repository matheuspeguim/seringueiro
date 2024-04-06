// home_page_event.dart

import 'package:firebase_auth/firebase_auth.dart';

abstract class HomePageEvent {}

class FetchUserDataEvent extends HomePageEvent {}

class FetchPropertiesEvent extends HomePageEvent {
  User user;

  FetchPropertiesEvent({required this.user});
}
