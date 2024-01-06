// seringuia_state.dart

abstract class SeringuiaState {}

class SeringuiaInitial extends SeringuiaState {}

class ContentLoading extends SeringuiaState {}

class ContentLoaded extends SeringuiaState {
  final List<ContentSection> contentSections;

  ContentLoaded(this.contentSections);
}

class SeringuiaError extends SeringuiaState {
  final String message;

  SeringuiaError(this.message);
}

// Classe para representar uma seção de conteúdo
class ContentSection {
  final String title;
  final String content;

  ContentSection({required this.title, required this.content});
}
