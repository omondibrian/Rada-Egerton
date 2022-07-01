import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class ForumBloc extends Bloc<ForumChatEvent, ForumState> {
  final ChatRepository chatRepo;
  final String forumId;
  final RadaApplicationProvider appProvider;
  late StreamSubscription<ChatPayload> _streamSubscription;

  ForumBloc({
    required this.forumId,
    required this.chatRepo,
    required this.appProvider,
  }) : super(
          const ForumState(),
        ) {
    //Listen to new recived forum messages
    _streamSubscription = chatRepo.forumChatStream.listen((chat) {
      add(ForumChatReceived(chat));
    });

    on<ForumChatStarted>(_forumChatStarted);
    on<ForumChatSelected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: event.forumchat),
      ),
    );
    on<ForumChatUnselected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: null),
      ),
    );
    on<ForumChatReceived>(_forumChatReceived);
    on<ForumChatSend>(_forumChatSend);
    on<ForumUnsubscribe>(_forumUnsubscribe);
  }

  FutureOr<void> _forumChatStarted(
    ForumChatEvent event,
    Emitter<ForumState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.loading),
    );
    final res = await chatRepo.initChats();
    res.fold(
      (infomessage) => emit(
        state.copyWith(
          forumMsgs: chatRepo.forumchat
              .where((chat) => chat.groupsId == forumId)
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

  FutureOr<void> _forumChatReceived(
    ForumChatReceived event,
    Emitter<ForumState> emit,
  ) {
    if (event.forumchat.reciepient == forumId) {
      emit(
        state.copyWith(
          forumMsgs: [...state.chats, event.forumchat],
        ),
      );
    }
  }

  FutureOr<void> _forumChatSend(
    ForumChatSend event,
    Emitter<ForumState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.submiting),
    );
    final res = await chatRepo.sendForumChat(event.forumchat);
    res.fold(
      (chat) => emit(
        state.copyWith(
          status: ServiceStatus.submissionSucess,
          forumMsgs: [...state.chats, event.forumchat],
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

  FutureOr<void> _forumUnsubscribe(
    ForumUnsubscribe event,
    Emitter<ForumState> emit,
  ) async {
    emit(
      state.copyWith(
        infoMessage: InfoMessage("Leaving forum please wait", MessageType.info),
      ),
    );
    final res = await appProvider.leaveGroup(forumId);
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
