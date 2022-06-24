part of 'bloc.dart';

abstract class GroupChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupChatStarted extends GroupChatEvent {}

class GroupChatSelected extends GroupChatEvent {
  @override
  List<Object?> get props => [groupChat];

  final ChatPayload groupChat;
  GroupChatSelected(this.groupChat);
}

class GroupChatUnselected extends GroupChatEvent {}

class GroupChatSend extends GroupChatEvent {
  final ChatPayload groupChat;

  @override
  List<Object?> get props => [groupChat];
  GroupChatSend(
    this.groupChat,
  );
}

class GroupChatReceived extends GroupChatEvent {
  @override
  List<Object?> get props => [groupChat];

  final ChatPayload groupChat;
  GroupChatReceived(this.groupChat);
}

class GroupUnsubscribe extends GroupChatEvent {}
