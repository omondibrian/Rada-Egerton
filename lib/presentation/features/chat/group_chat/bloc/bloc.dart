import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/providers/application_provider.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/data/status.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class GroupBloc extends Bloc<GroupChatEvent, GroupState> {
  final ChatRepository chatRepo;
  final String groupId;
  late StreamSubscription<ChatPayload> _streamSubscription;
  final RadaApplicationProvider appProvider;
  final ScrollController controller = ScrollController();

  GroupBloc({
    required this.groupId,
    required this.chatRepo,
    required this.appProvider,
  }) : super(
          const GroupState(),
        ) {
    //Listen to new recived group messages
    _streamSubscription = chatRepo.groupChatStream.listen((chat) {
      print("_____stream__$chat");
      add(GroupChatReceived(chat));
    });

    on<GroupChatStarted>(_groupChatStarted);
    on<GroupChatSelected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: event.groupChat),
      ),
    );
    on<GroupChatUnselected>(
      (event, emit) => emit(
        state.copyWith(retainSelectedChat: false),
      ),
    );
    on<GroupChatReceived>(_groupChatReceived);
    on<GroupChatSend>(_groupChatSend);
    on<GroupUnsubscribe>(_groupUnsubscribe);
    on<DeleteGroup>(_groupDeleteGroup);
  }

  FutureOr<void> _groupChatStarted(
    GroupChatEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(status: ServiceStatus.loading),
    );
    final res = await chatRepo.initChats();
    res.fold(
      (infomesage) => emit(
        state.copyWith(
          forumMsgs: chatRepo.groupchat
              .where((chat) => chat.groupsId == groupId)
              .toList(),
        ),
      ),
      (errormassage) => emit(
        state.copyWith(
          status: ServiceStatus.loadingFailure,
          infoMessage: InfoMessage(
            errormassage.message,
            MessageType.error,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _groupChatReceived(
    GroupChatReceived event,
    Emitter<GroupState> emit,
  ) {
    if (event.groupChat.groupsId == groupId) {
      emit(
        state.copyWith(
          forumMsgs: [...state.chats, event.groupChat],
        ),
      );
      controller.animateTo(
        controller.position.maxScrollExtent + 500,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  FutureOr<void> _groupChatSend(
    GroupChatSend event,
    Emitter<GroupState> emit,
  ) async {
    if (state.status == ServiceStatus.submiting) return;
    emit(
      state.copyWith(status: ServiceStatus.submiting),
    );
    final res = await chatRepo.sendGroupChat(
      groupId: groupId,
      message: event.message,
      senderId: GlobalConfig.instance.user.id.toString(),
      picture: event.picture,
      reply: state.selectedChat?.id.toString(),
      retryLog: (value) => emit(
        state.copyWith(
          infoMessage: InfoMessage("Retrying..", MessageType.error),
        ),
      ),
    );
    res.fold(
      (chat) {
        if (chat.groupsId == groupId) {
          emit(
            state.copyWith(
              status: ServiceStatus.submissionSucess,
              forumMsgs: [...state.chats, chat],
              infoMessage: InfoMessage("Chat send", MessageType.success),
              retainSelectedChat: false,
            ),
          );
        }
      },
      (r) => emit(
        state.copyWith(
          infoMessage: InfoMessage.fromError(r),
          status: ServiceStatus.submissionFailure,
        ),
      ),
    );
  }

  FutureOr<void> _groupUnsubscribe(
    GroupUnsubscribe event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        infoMessage:
            InfoMessage("Leaving group please wait", MessageType.success),
      ),
    );
    final res = await appProvider.leaveGroup(groupId);
    res.fold(
      (infomessage) => emit(
        state.copyWith(infoMessage: infomessage, subscribed: false),
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

  FutureOr<void> _groupDeleteGroup(
    DeleteGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        infoMessage:
            InfoMessage("Deleting group, please wait...", MessageType.success),
      ),
    );
    final res = await appProvider.deleteGroup(groupId);
    res.fold(
      (infomessage) => emit(
        state.copyWith(infoMessage: infomessage, subscribed: false),
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
