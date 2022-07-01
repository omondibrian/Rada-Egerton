import "package:audioplayers/audioplayers.dart";

class NotificationAudio {
  NotificationAudio._();
  static final messageSendAudio = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency)
    ..setSourceAsset("sounds/send.ogg");
  static final messageReceivedAudio = AudioPlayer()
    ..setPlayerMode(PlayerMode.lowLatency)
    ..setSourceAsset("sounds/received.ogg");
  static messageSend() => messageReceivedAudio.resume();
  static messageReceived() => messageSendAudio.resume();
}
