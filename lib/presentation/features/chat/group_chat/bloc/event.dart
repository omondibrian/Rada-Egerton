part of 'bloc.dart';

abstract class GroupChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupChatStarted extends GroupChatEvent {}
class GroupChatRefresh extends GroupChatEvent {}

class GroupChatSelected extends GroupChatEvent {
  @override
  List<Object?> get props => [groupChat];

  final ChatPayload groupChat;
  GroupChatSelected(this.groupChat);
}

class GroupChatUnselected extends GroupChatEvent {}

class GroupChatSend extends GroupChatEvent {
  final String message;
  final File? picture;
  final File? video;

  @override
  List<Object?> get props => [message, video, picture];
  GroupChatSend({
    this.picture,
    this.video,
    required this.message,
  });
}

class GroupChatReceived extends GroupChatEvent {
  @override
  List<Object?> get props => [groupChat];

  final ChatPayload groupChat;
  GroupChatReceived(this.groupChat);
}

class GroupUnsubscribe extends GroupChatEvent {}

class DeleteGroup extends GroupChatEvent {}
