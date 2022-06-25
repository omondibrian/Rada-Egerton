part of "bloc.dart";

class PrivateChatState extends Equatable {
  final ChatPayload? selectedChat;
  final List<ChatPayload> chats;
  final ServiceStatus status;
  final InfoMessage? infoMessage;
  final User? recepient;
  final ServiceStatus recepientProfileStatus;
  const PrivateChatState({
    this.selectedChat,
    this.chats = const [],
    this.status = ServiceStatus.initial,
    this.infoMessage,
    this.recepient,
    this.recepientProfileStatus = ServiceStatus.initial,
  });

  PrivateChatState copyWith({
    ChatPayload? selectedChat,
    List<ChatPayload>? forumMsgs,
    ServiceStatus? status,
    InfoMessage? infoMessage,
    User? user,
    ServiceStatus? recepientProfileStatus,
  }) {
    return PrivateChatState(
      selectedChat: selectedChat ?? this.selectedChat,
      chats: forumMsgs ?? chats,
      status: status ?? this.status,
      infoMessage: infoMessage,
      recepient: user ?? recepient,
      recepientProfileStatus:
          recepientProfileStatus ?? this.recepientProfileStatus,
    );
  }

  @override
  List<Object?> get props => [
        selectedChat,
        status,
        infoMessage,
        chats,
        recepient,
        recepientProfileStatus
      ];
}
