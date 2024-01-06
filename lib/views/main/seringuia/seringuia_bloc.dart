// seringuia_bloc.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'seringuia_event.dart';
import 'seringuia_state.dart';

class SeringuiaBloc extends Bloc<SeringuiaEvent, SeringuiaState> {
  final User user;

  SeringuiaBloc({required this.user}) : super(SeringuiaInitial()) {
    on<FetchContentEvent>(_onFetchContent);
  }

  Future<void> _onFetchContent(
      FetchContentEvent event, Emitter<SeringuiaState> emit) async {
    emit(ContentLoading());
    try {
      // Implemente a lógica para buscar informações relevantes
      // Substitua a linha abaixo pela sua lógica de busca de dados
      var content = await fetchContent();
      emit(ContentLoaded(content.cast<ContentSection>()));
    } catch (e) {
      emit(SeringuiaError("Erro ao buscar informações: $e"));
    }
  }

  // Simulação de função de busca de conteúdo
  Future<List<String>> fetchContent() async {
    // Simule a busca de conteúdo
    await Future.delayed(Duration(seconds: 2));
    return [
      'Informação 1',
      'Informação 2',
      'Informação 3'
    ]; // Exemplo de dados retornados
  }
}
