// jotinha_page_bloc.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'jotinha_event.dart';
import 'jotinha_state.dart';

class JotinhaBloc extends Bloc<JotinhaEvent, JotinhaState> {
  final User user;
  JotinhaBloc({required this.user}) : super(JotinhaPageInitial()) {
    on<FetchNewsEvent>(_onFetchNews);
  }

  Future<void> _onFetchNews(
      FetchNewsEvent event, Emitter<JotinhaState> emit) async {
    emit(NewsLoading());
    try {
      // Adicione aqui a lógica para buscar as notícias
    } catch (e) {
      emit(NewsError("Erro ao buscar notícias: $e"));
    }
  }

  // Simulação de uma função que busca notícias
  Future<List<News>> fetchNews() async {
    await Future.delayed(Duration(seconds: 2)); // Simulação de um delay
    return [News(title: 'Título da Notícia', content: 'Conteúdo da notícia')];
  }
}

// Uma classe básica para representar uma notícia
class News {
  final String title;
  final String content;

  News({required this.title, required this.content});
}
