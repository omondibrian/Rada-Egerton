import "package:audioplayers/audioplayers.dart";

class NotificationAudio {
  NotificationAudio._();
  static final _messageSendAudio = AudioPlayer();
  static final _messageReceivedAudio = AudioPlayer();
  static messageSend() => _messageSendAudio.play(AssetSource("sounds/send.ogg"),
      mode: PlayerMode.lowLatency);
  static messageReceived() => _messageReceivedAudio
      .play(AssetSource("sounds/send.ogg"), mode: PlayerMode.lowLatency);
}
