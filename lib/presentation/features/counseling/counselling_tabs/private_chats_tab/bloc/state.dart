part of "bloc.dart";

class PrivateChatTabState extends Equatable {
  final List<ChatPayload> conversations;
  final ServiceStatus status;
  final InfoMessage? infoMessage;

  @override
  List<Object?> get props => [conversations, status, infoMessage];
  const PrivateChatTabState({
    this.conversations = const [],
    this.status = ServiceStatus.initial,
    this.infoMessage,
  });

  PrivateChatTabState copyWith({
    ChatPayload? selectedChat,
    List<ChatPayload>? conversations,
    ServiceStatus? status,
    InfoMessage? infoMessage,
    bool? subscribed,
  }) {
    return PrivateChatTabState(
      conversations: conversations ?? this.conversations,
      status: status ?? this.status,
      infoMessage: infoMessage,
    );
  }
}
