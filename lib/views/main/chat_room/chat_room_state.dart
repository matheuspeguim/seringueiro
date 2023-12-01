// chat_room_state.dart

abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ConversationsLoading extends ChatRoomState {}

class ConversationsLoaded extends ChatRoomState {
  final List<Conversation> conversations;

  ConversationsLoaded(this.conversations);
}

class SendMessageLoading extends ChatRoomState {}

class SendMessageSuccess extends ChatRoomState {}

class ChatRoomError extends ChatRoomState {
  final String message;

  ChatRoomError(this.message);
}

// Classe para representar uma conversa (Você precisará definir isso)
class Conversation {
  final String id;
  final String lastMessage;

  Conversation({required this.id, required this.lastMessage});
}
