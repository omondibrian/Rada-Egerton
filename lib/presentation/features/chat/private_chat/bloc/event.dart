part of 'bloc.dart';

abstract class PrivateChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrivateChatStarted extends PrivateChatEvent {}

class PrivateChatSelected extends PrivateChatEvent {
  @override
  List<Object?> get props => [privatechat];

  final ChatPayload privatechat;
  PrivateChatSelected(this.privatechat);
}

class PrivateChatUnselected extends PrivateChatEvent {}

class PrivateChatSend extends PrivateChatEvent {
  final ChatPayload privatechat;

  @override
  List<Object?> get props => [privatechat];
  PrivateChatSend(
    this.privatechat,
  );
}

class PrivateChatReceived extends PrivateChatEvent {
  @override
  List<Object?> get props => [privatechat];

  final ChatPayload privatechat;
  PrivateChatReceived(this.privatechat);
}

