part of 'bloc.dart';

abstract class ForumChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForumChatStarted extends ForumChatEvent {}

class ForumChatSelected extends ForumChatEvent {
  @override
  List<Object?> get props => [forumchat];

  final ChatPayload forumchat;
  ForumChatSelected(this.forumchat);
}

class ForumChatUnselected extends ForumChatEvent {}

class ForumChatSend extends ForumChatEvent {
  final ChatPayload forumchat;

  @override
  List<Object?> get props => [forumchat];
  ForumChatSend(
    this.forumchat,
  );
}

class ForumChatReceived extends ForumChatEvent {
  @override
  List<Object?> get props => [forumchat];

  final ChatPayload forumchat;
  ForumChatReceived(this.forumchat);
}

class ForumUnsubscribe extends ForumChatEvent {}
