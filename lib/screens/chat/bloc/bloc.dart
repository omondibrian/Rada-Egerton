import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/entities/ChatDto.dart';
import 'package:rada_egerton/repository/chat_repository.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart' as chat;
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/utils/main.dart';

part 'state.dart';
part 'event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepo = ChatRepository();
  late Channel channel;
  late PusherClient _pusher;
  String _channelName = "radaComms";

  ChatBloc() : super(ChatState()) {
    on<ChatStarted>((event, emit) => chatRepo.getChats().then((value) => null));
    on<ChatSelected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: event.chat),
      ),
    );
    on<ChatUnselected>(
      (event, emit) => emit(
        state.copyWith(selectedChat: null),
      ),
    );
    on<ChatModeChanged>(
      (event, emit) => state.copyWith(chatType: event.mode),
    );
    on<ChatRecepientChanged>(
      (event, emit) => emit(
        state.copyWith(recepient: event.recepient),
      ),
    );

    _pusher = Pusher(
      appKey: GlobalConfig.instance.pusherApiKey,
      token: GlobalConfig.instance.authToken,
    ).getConnection();
    this.channel = _pusher.subscribe(
      "$_channelName${GlobalConfig.instance.user?.id}",
    );

    channel.bind(chat.ChatEvent.CHAT, (PusherEvent? event) {});
  }
}
