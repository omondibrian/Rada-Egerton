import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/data/entities/chat_dto.dart';
import 'package:rada_egerton/data/repository/chat_repository.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart' as chat;
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/resources/utils/main.dart';

part 'state.dart';
part 'event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepo = ChatRepository();
  late Channel channel;
  late PusherClient _pusher;
  final String _channelName = "radaComms";

  ChatBloc() : super(const ChatState()) {
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

    on<ChatRecepientChanged>(
      (event, emit) => emit(
        state.copyWith(recepient: event.recepient, chatType: event.mode),
      ),
    );

    _pusher = Pusher(
      appKey: GlobalConfig.instance.pusherApiKey,
      token: GlobalConfig.instance.authToken,
    ).getConnection();
    channel = _pusher.subscribe(
      "$_channelName${GlobalConfig.instance.user.id}",
    );

    channel.bind(chat.ChatEvent.CHAT, (PusherEvent? event) {});
  }
}
