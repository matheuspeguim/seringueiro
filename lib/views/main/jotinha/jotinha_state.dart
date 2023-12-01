// jotinha_page_state.dart

abstract class JotinhaState {}

class JotinhaPageInitial extends JotinhaState {}

class NewsLoading extends JotinhaState {}

class NewsLoaded extends JotinhaState {}

class NewsError extends JotinhaState {
  final String message;

  NewsError(this.message);
}

// Você precisará definir uma classe 'News' para representar uma notícia.
