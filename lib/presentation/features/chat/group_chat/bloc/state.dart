part of "bloc.dart";

class GroupState extends Equatable {
  final ChatPayload? selectedChat;
  final List<ChatPayload> chats;
  final ServiceStatus status;
  final InfoMessage? infoMessage;
  final bool subscribed;
  const GroupState({
    this.selectedChat,
    this.chats = const [],
    this.status = ServiceStatus.initial,
    this.infoMessage,
    this.subscribed = true,
  });

  GroupState copyWith({
    ChatPayload? selectedChat,
    List<ChatPayload>? forumMsgs,
    ServiceStatus? status,
    InfoMessage? infoMessage,
    bool? subscribed,
  }) {
    return GroupState(
      selectedChat: selectedChat ?? this.selectedChat,
      chats: forumMsgs ?? chats,
      status: status ?? this.status,
      infoMessage: infoMessage,
      subscribed: subscribed ?? this.subscribed,
    );
  }

  @override
  List<Object?> get props => [
        selectedChat,
        status,
        infoMessage,
        chats,
        subscribed,
      ];
}
