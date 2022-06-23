part of "bloc.dart";

class Recepient extends Equatable {
  final int reciepient;
  final String title;
  final String imgUrl;

  const Recepient({
    this.title = "",
    this.imgUrl = "",
    this.reciepient = 0,
  });
  @override
  List<Object?> get props => [
        reciepient,
        title,
        imgUrl,
      ];
}

class ChatState extends Equatable {
  final ChatPayload? selectedChat;
  final Recepient? recepient;
  final ChatModes? chatType;

  final List<ChatPayload> peerMsgs;
  final List<ChatPayload> forumMsgs;
  final List<ChatPayload> groupMsgs;

  const ChatState(
      {this.selectedChat,
      this.peerMsgs = const [],
      this.groupMsgs = const [],
      this.forumMsgs = const [],
      this.recepient = const Recepient(),
      this.chatType});

  ChatState copyWith({
    ChatPayload? selectedChat,
    List<ChatPayload>? peerMsgs,
    List<ChatPayload>? forumMsgs,
    List<ChatPayload>? groupMsgs,
    Recepient? recepient,
    ChatModes? chatType,
  }) {
    return ChatState(
        selectedChat: selectedChat ?? this.selectedChat,
        forumMsgs: forumMsgs ?? this.forumMsgs,
        peerMsgs: peerMsgs ?? this.peerMsgs,
        groupMsgs: groupMsgs ?? this.peerMsgs,
        recepient: recepient ?? this.recepient,
        chatType: chatType ?? this.chatType);
  }

  @override
  List<Object?> get props => [
        selectedChat,
        peerMsgs,
        forumMsgs,
        groupMsgs,
        recepient,
        chatType,
      ];
}
