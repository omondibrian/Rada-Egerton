part of 'bloc.dart';

abstract class PrivateChatTabEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrivateChatTabStarted extends PrivateChatTabEvent {}

class PrivateTabChatReceived extends PrivateChatTabEvent {
  @override
  List<Object?> get props => [privatechat];

  final ChatPayload privatechat;
  PrivateTabChatReceived(this.privatechat);
}
