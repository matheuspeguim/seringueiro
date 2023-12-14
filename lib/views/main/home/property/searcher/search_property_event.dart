abstract class SearchPropertyEvent {}

class StartSearch extends SearchPropertyEvent {}

class SearchByName extends SearchPropertyEvent {
  final String propertyName;

  SearchByName(this.propertyName);
}
