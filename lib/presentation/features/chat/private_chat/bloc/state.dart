part of "bloc.dart";

class PrivateChatState extends Equatable {
  final ChatPayload? selectedChat;
  final List<ChatPayload> chats;
  final ServiceStatus status;
  final InfoMessage? infoMessage;
  const PrivateChatState({
    this.selectedChat,
    this.chats = const [],
    this.status = ServiceStatus.initial,
    this.infoMessage,
  });

  PrivateChatState copyWith({
    ChatPayload? selectedChat,
    List<ChatPayload>? forumMsgs,
    ServiceStatus? status,
    InfoMessage? infoMessage,
  }) {
    return PrivateChatState(
      selectedChat: selectedChat ?? this.selectedChat,
      chats: forumMsgs ?? chats,
      status: status ?? this.status,
      infoMessage: infoMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedChat,
        status,
        infoMessage,
        chats,
      ];
}
