import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asalto_time/timer/model/round_model.dart';
import 'package:asalto_time/timer/model/round_config.dart';


final roundConfig = RoundConfig(totalRounds: 2, totalSeconds: 15, secondsBreak: 10);

final timerProvider = StateNotifierProvider<TimerNotifier, RoundCounter>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<RoundCounter> {
  TimerNotifier() : super(RoundCounter(seconds: roundConfig.totalSeconds));

  late Timer _timer;
  bool isActivateTime = false;
  final player = AudioPlayer();

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      await decrease();
      state = state.copyWith(seconds: state.seconds, isRunning: true);
      if (state.seconds == 0) {
        state = state.copyWith(
            seconds: state.secondsReset,
            isSecondBreak: false,
            isRunning: false);
        _timer.cancel();
      }
    });
  }

  void pauseTimer() {
    _timer.cancel();
    state = state.copyWith(seconds: state.seconds, isRunning: false);
  }

  void resetTimer() {
    pauseTimer();
    state = state.copyWith(seconds: roundConfig.totalSeconds, asaltoActual: 1);
  }

  Future<void> decrease() async {
    if (state.seconds > 0) {
      int second = state.seconds;
      if (state.isRunning && !state.isSecondBreak) {
        await playCampana(second, 'campana.mp3');
        print("Suena: ${player.state}");
      } else if (state.isRunning && state.isSecondBreak) {
        print("Tiempo retroceso");
        print("Suena: ${player.state}");
        await playCampana(second, 'timeRetroceso.mp3');
      }
      second--;
      state = state.copyWith(seconds: second);
    }
    if (state.seconds == 0 && state.isRunning && !state.isSecondBreak) {
      state = state.copyWith(seconds: roundConfig.totalSeconds, isSecondBreak: true);
    }
    print("Antes de siguient asalto");
    if (state.seconds == 0 && state.isRunning && state.isSecondBreak) {
      siguienteAsalto();
    }
  }

  void siguienteAsalto() {
    int asalto = state.asaltoActual + 1;
    if (asalto <= roundConfig.totalRounds) {
      state = state.copyWith(
          seconds: roundConfig.totalSeconds, asaltoActual: asalto, isSecondBreak: false);
      print("Siguient Asalto");
    }
  }

  Future<void> playCampana(int second, String fileSound) async {
    print("Tiempo: ${second}");
    if (second == 11) {
      await player.play(AssetSource(fileSound));
    }
  }

  bool get isActivate => state.isRunning;

  bool get isBreak => state.isSecondBreak;
}
