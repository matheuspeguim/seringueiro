// chat_room_event.dart

abstract class ChatRoomEvent {}

class FetchConversationsEvent extends ChatRoomEvent {}

class SendMessageEvent extends ChatRoomEvent {
  final String message;

  SendMessageEvent(this.message);
}
