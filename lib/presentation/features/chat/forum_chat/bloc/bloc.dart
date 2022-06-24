import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class ForumnBloc extends Bloc<ForumnChatEvent, ForumnState> {
  final ChatRepository chatRepo;
  final String forumnId;
  late StreamSubscription<ChatPayload> _streamSubscription;

  ForumnBloc({required this.forumnId, required this.chatRepo})
      : super(
          const ForumnState(),
        ) {
    //Listen to new recived forumn messages
    _streamSubscription = chatRepo.forumnChatStream.listen((chat) {
      add(ForumnChatReceived(chat));
    });

    on<ForumnChatStarted>(_forumnChatStarted);
    on<ForumnChatSelected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: event.forumnchat),
      ),
    );
    on<ForumnChatUnselected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: null),
      ),
    );
    on<ForumnChatReceived>(_forumnChatReceived);
    on<ForumnChatSend>(_forumnChatSend);
    on<ForumnUnsubscribe>(_forumnUnsubscribe);
  }

  FutureOr<void> _forumnChatStarted(
    ForumnChatEvent event,
    Emitter<ForumnState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.loading),
    );
    final res = await chatRepo.initChats();
    res.fold(
      (infomessage) => emit(
        state.copyWith(
          forumMsgs: chatRepo.forumnchat
              .where((chat) => chat.groupsId == forumnId)
              .toList(),
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

  FutureOr<void> _forumnChatReceived(
    ForumnChatReceived event,
    Emitter<ForumnState> emit,
  ) {
    if (event.forumnchat.reciepient == forumnId) {
      emit(
        state.copyWith(
          forumMsgs: [...state.chats, event.forumnchat],
        ),
      );
    }
  }

  FutureOr<void> _forumnChatSend(
    ForumnChatSend event,
    Emitter<ForumnState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.submiting),
    );
    final res = await chatRepo.sendForumnChat(event.forumnchat);
    res.fold(
      (chat) => emit(
        state.copyWith(
          status: ServiceStatus.submissionSucess,
          forumMsgs: [...state.chats, event.forumnchat],
          infoMessage: InfoMessage("Chat send", MessageType.success),
        ),
      ),
      (r) => emit(
        state.copyWith(
          infoMessage: InfoMessage("Chat send", MessageType.success),
          status: ServiceStatus.submissionFailure,
        ),
      ),
    );
  }

  FutureOr<void> _forumnUnsubscribe(
    ForumnUnsubscribe event,
    Emitter<ForumnState> emit,
  ) async {
    emit(
      state.copyWith(
        infoMessage:
            InfoMessage("Leaving forumn please wait", MessageType.info),
      ),
    );
    final res = await chatRepo.leaveForumn(forumnId);
    res.fold(
      (infomessage) => emit(
        state.copyWith(
          infoMessage: infomessage,
          subscribed: false,
        ),
      ),
      (errorMessage) => emit(
        state.copyWith(
          infoMessage: InfoMessage(
            errorMessage.message,
            MessageType.error,
          ),
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
