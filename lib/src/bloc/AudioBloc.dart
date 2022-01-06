import 'package:audioplayers/audioplayers.dart';
import 'bloc_provider.dart';
import 'dart:async';
import 'package:hiltonSample/src/resource/repository/BookRepository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';

class AudioBloc implements BlocBase {
  AudioBloc();

  AudioPlayer audioPlayer = AudioPlayer();

  final totalDurationStreamController = BehaviorSubject<Duration>();

  Stream<Duration> get totalDurationStream =>
      totalDurationStreamController.stream;
  final updatedPositionStreamController = BehaviorSubject<Duration>();

  Stream<Duration> get updatedPositionStream =>
      updatedPositionStreamController.stream;

  final audioStateStreamController = BehaviorSubject<String>();

  Stream<String> get audioStateStream => audioStateStreamController.stream;

  initAudio() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalDurationStreamController.sink.add(updatedDuration);
    });
    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      updatedPositionStreamController.sink.add(updatedPosition);
    });

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == AudioPlayerState.STOPPED)
        audioStateStreamController.sink.add("Stopped");
      if (playerState == AudioPlayerState.PLAYING)
        audioStateStreamController.sink.add("Playing");
      if (playerState == AudioPlayerState.PAUSED)
        audioStateStreamController.sink.add("Paused");
    });
  }

  playAudio(String url) {
    audioPlayer.play(url);
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
  }

  void dispose() {
    totalDurationStreamController.close();
    audioStateStreamController.close();
    updatedPositionStreamController.close();
  }
}
