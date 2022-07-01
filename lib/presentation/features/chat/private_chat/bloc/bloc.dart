import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/entities/user_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class PrivateChatBloc extends Bloc<PrivateChatEvent, PrivateChatState> {
  final ChatRepository chatRepo;
  final String recepientId;
  late StreamSubscription<ChatPayload> _streamSubscription;
  final RadaApplicationProvider appProvider;

  PrivateChatBloc(
      {required this.recepientId,
      required this.appProvider,
      required this.chatRepo})
      : super(
          const PrivateChatState(),
        ) {
    //Listen to new recived PrivateChat messages
    _streamSubscription = chatRepo.privateChatStream.listen((chat) {
      add(PrivateChatReceived(chat));
    });

    on<PrivateChatStarted>(_privateChatStarted);
    on<PrivateChatSelected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: event.privatechat),
      ),
    );
    on<PrivateChatUnselected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: null),
      ),
    );
    on<PrivateChatReceived>(_privateChatReceived);
    on<PrivateChatSend>(_privateChatSend);
    on<RecepientDataRequested>(_initRecepient);
  }

  FutureOr<void> _privateChatStarted(
    PrivateChatEvent event,
    Emitter<PrivateChatState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.loading),
    );
    final res = await chatRepo.initChats();
    res.fold(
      (successInfoMessage) => emit(
        state.copyWith(forumMsgs: chatRepo.privatechat),
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

  FutureOr<void> _privateChatReceived(
    PrivateChatReceived event,
    Emitter<PrivateChatState> emit,
  ) {
    if (event.privatechat.reciepient == recepientId) {
      emit(
        state.copyWith(
          forumMsgs: [...state.chats, event.privatechat],
        ),
      );
    }
  }

  FutureOr<void> _privateChatSend(
    PrivateChatSend event,
    Emitter<PrivateChatState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.submiting),
    );
    final res = await chatRepo.sendPrivateChat(event.privatechat);
    res.fold(
      (chat) => emit(
        state.copyWith(
          status: ServiceStatus.submissionSucess,
          forumMsgs: [...state.chats, event.privatechat],
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

  FutureOr<void> _initRecepient(
    RecepientDataRequested event,
    Emitter<PrivateChatState> emit,
  ) async {
    await appProvider
        .getUser(
          userId: int.parse(recepientId),
        )
        .then(
          (res) => res.fold(
            (user) => emit(
              state.copyWith(
                user: user,
                recepientProfileStatus: ServiceStatus.loadingSuccess,
              ),
            ),
            (info) => emit(
              state.copyWith(
                recepientProfileStatus: ServiceStatus.loadingFailure,
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
