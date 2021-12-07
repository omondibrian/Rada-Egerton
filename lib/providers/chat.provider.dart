import 'package:flutter/foundation.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rada_egerton/config.dart';
import 'package:rada_egerton/services/auth/main.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/services/utils.dart';

class ChatProvider extends ChangeNotifier {
  late PusherClient _pusher;
  late Channel channel;
  String _channelName = "radaComms";
  late String _userId;
  ChatProvider() {
    init();
  }
  void init() async {
    String? _autoken = await ServiceUtility.getAuthToken();
    _pusher =
        Pusher(appKey: pusherApiKey, token: _autoken ?? "").getConnection();
    var result = await AuthServiceProvider().getProfile();
    result!.fold((user) => {this._userId = user.id}, (error) => print(error));
    privateChannel();
  }

  void privateChannel() {
    this.channel = _pusher.subscribe("$_channelName$_userId");
    channel.bind(ChatEvent.CHAT, (PusherEvent? event) {
      print(event!.data);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.unbind(ChatEvent.CHAT);
  }
}
