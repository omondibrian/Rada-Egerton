import "package:audioplayers/audioplayers.dart";

class NotificationAudio {
  NotificationAudio._();
  static final _messageSendAudio = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency)
    ..setSourceAsset("sounds/send.ogg");
  static final _messageReceivedAudio = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency)
    ..setSourceAsset("sounds/send.ogg");
  static messageSend() => _messageReceivedAudio.resume();
  static messageReceived() => _messageSendAudio.resume();
}
