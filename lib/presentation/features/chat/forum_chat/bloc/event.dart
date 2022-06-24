part of 'bloc.dart';

abstract class ForumnChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForumnChatStarted extends ForumnChatEvent {}

class ForumnChatSelected extends ForumnChatEvent {
  @override
  List<Object?> get props => [forumnchat];

  final ChatPayload forumnchat;
  ForumnChatSelected(this.forumnchat);
}

class ForumnChatUnselected extends ForumnChatEvent {}

class ForumnChatSend extends ForumnChatEvent {
  final ChatPayload forumnchat;

  @override
  List<Object?> get props => [forumnchat];
  ForumnChatSend(
    this.forumnchat,
  );
}

class ForumnChatReceived extends ForumnChatEvent {
  @override
  List<Object?> get props => [forumnchat];

  final ChatPayload forumnchat;
  ForumnChatReceived(this.forumnchat);
}

class ForumnUnsubscribe extends ForumnChatEvent {}
