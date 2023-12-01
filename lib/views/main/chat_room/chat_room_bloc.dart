// chat_room_bloc.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final User user;
  ChatRoomBloc({required this.user}) : super(ChatRoomInitial()) {
    on<FetchConversationsEvent>(_onFetchConversations);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onFetchConversations(
      FetchConversationsEvent event, Emitter<ChatRoomState> emit) async {
    emit(ConversationsLoading());
    try {
      // Implemente a lógica para buscar as conversas
      List<Conversation> conversations = await fetchConversations();
      emit(ConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatRoomError("Erro ao buscar conversas: $e"));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatRoomState> emit) async {
    emit(SendMessageLoading());
    try {
      // Implemente a lógica para enviar a mensagem
      await sendMessage(event.message);
      emit(SendMessageSuccess());
    } catch (e) {
      emit(ChatRoomError("Erro ao enviar mensagem: $e"));
    }
  }

  // Simulação de funções de busca de conversas e envio de mensagens
  Future<List<Conversation>> fetchConversations() async {
    await Future.delayed(Duration(seconds: 2)); // Simulação de um delay
    return [Conversation(id: '1', lastMessage: 'Olá!')]; // Exemplo de dado
  }

  Future<void> sendMessage(String message) async {
    await Future.delayed(Duration(seconds: 1)); // Simulação de um delay
    // Implemente a lógica de envio de mensagem
  }
}
