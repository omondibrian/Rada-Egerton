part of 'bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {}



class ChatSelected extends ChatEvent {
  @override
  List<Object?> get props => [chat];

  final ChatPayload chat;
  ChatSelected(this.chat);
}

class ChatUnselected extends ChatEvent {}

class ChatSend extends ChatEvent {
  final ChatPayload chat;
  final ChatModes chatMode;

  @override
  List<Object?> get props => [chat, chatMode];
  ChatSend(this.chat, this.chatMode);
}

class ChatReceived extends ChatEvent {
  @override
  List<Object?> get props => [chat];

  final ChatPayload chat;
  ChatReceived(this.chat);
}

class ChatRecepientChanged extends ChatEvent {
  final Recepient recepient;
  final chat.ChatModes mode;

  ChatRecepientChanged(this.recepient, this.mode);

  @override
  List<Object?> get props => [recepient, mode];
}
