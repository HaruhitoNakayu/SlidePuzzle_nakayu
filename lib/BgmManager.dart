import 'package:audioplayers/audioplayers.dart';

class BgmManager {
  static final BgmManager _instance = BgmManager._internal();
  late AudioPlayer player;

  factory BgmManager() {
    return _instance;
  }

  BgmManager._internal() {
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.loop);
    player.setSource(AssetSource('audio/bgm.mp3'));
  }

  void play() {
    player.resume();
  }

  void stop() {
    player.pause();
  }

  void dispose() {
    player.dispose();
  }
}
