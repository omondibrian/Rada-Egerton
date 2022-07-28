part of 'bloc.dart';

abstract class PrivateChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrivateChatStarted extends PrivateChatEvent {}

class PrivateChatRefresh extends PrivateChatEvent {}

class PrivateChatSelected extends PrivateChatEvent {
  @override
  List<Object?> get props => [privatechat];

  final ChatPayload privatechat;
  PrivateChatSelected(this.privatechat);
}

class PrivateChatUnselected extends PrivateChatEvent {}

class PrivateChatSend extends PrivateChatEvent {
  final String message;
  final File? picture;
  final File? video;

  @override
  List<Object?> get props => [message, video, picture];
  PrivateChatSend({
    this.picture,
    this.video,
    required this.message,
  });
}

class PrivateChatReceived extends PrivateChatEvent {
  @override
  List<Object?> get props => [privatechat];

  final ChatPayload privatechat;
  PrivateChatReceived(this.privatechat);
}

class RecepientDataRequested extends PrivateChatEvent {}
