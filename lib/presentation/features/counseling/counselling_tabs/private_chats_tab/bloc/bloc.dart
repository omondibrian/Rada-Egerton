import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class PrivateChatBloc extends Bloc<PrivateChatTabEvent, PrivateChatTabState> {
  final ChatRepository chatRepo;
  late StreamSubscription<ChatPayload> _streamSubscription;

  PrivateChatBloc({
    required this.chatRepo,
  }) : super(
          const PrivateChatTabState(),
        ) {
    _streamSubscription = chatRepo.privateChatStream.listen(
      (chat) {
        add(PrivateTabChatReceived(chat));
      },
    );
    on<PrivateChatTabStarted>(_privateChatStarted);
    on<PrivateTabChatReceived>(_privateChatReceived);
  }

  FutureOr<void> _privateChatStarted(
    PrivateChatTabEvent event,
    Emitter<PrivateChatTabState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.loading),
    );
    final res = await chatRepo.initChats();
    res.fold(
      (successInfoMessage) => emit(
        state.copyWith(
          conversations: _conversations(chatRepo.privatechat),
        ),
      ),
      (errorMessage) => emit(
        state.copyWith(
          status: ServiceStatus.loadingFailure,
          infoMessage: InfoMessage(
            errorMessage.message,
            MessageType.error,
          ),
        ),
      ),
    );
  }

  List<ChatPayload> _conversations(List<ChatPayload> chats) {
    List<String?> ids = [];
    List<ChatPayload> conversations = [];
    for (var c in chats) {
      if (!ids.contains(c.reciepient)) {
        ids.add(c.reciepient);
        conversations.add(c);
      }
    }
    return conversations;
  }

  FutureOr<void> _privateChatReceived(
    PrivateTabChatReceived event,
    Emitter<PrivateChatTabState> emit,
  ) {
    emit(
      state.copyWith(
        conversations: _conversations(
          [...state.conversations, event.privatechat],
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    _streamSubscription.cancel();
    return super.close();
  }
}
