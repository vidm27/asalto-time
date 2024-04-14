import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asalto_time/timer/model/round_model.dart';
import 'package:asalto_time/timer/model/round_config.dart';


final roundConfig = RoundConfig(totalRounds: 2, totalSeconds: 15, secondsBreak: 10);
final roundConfigProvider = StateProvider<RoundConfig>((ref) => roundConfig);

final timerProvider = StateNotifierProvider<TimerNotifier, RoundCounter>((ref) {
  final roundConfiguration = ref.watch(roundConfigProvider);
  return TimerNotifier(roundConfiguration: roundConfiguration);
});

class TimerNotifier extends StateNotifier<RoundCounter> {
  late Timer _timer;
  bool isActivateTime = false;
  final player = AudioPlayer();
  RoundConfig roundConfiguration;

  TimerNotifier({required this.roundConfiguration}) : super(RoundCounter(seconds: roundConfiguration.totalSeconds));

  void startTimer() {
    // Starts a timer that triggers a periodic function to update the state, check if the countdown is complete, and reset the timer if necessary.
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
    // Pauses the timer by canceling the current timer and updating the state to indicate that the timer is not running.
    _timer.cancel();
    state = state.copyWith(seconds: state.seconds, isRunning: false);
  }

  void resetTimer() {
    // Resets the timer by pausing it and updating the state with the total seconds and setting the current round to 1.
    pauseTimer();
    state = state.copyWith(seconds: roundConfiguration.totalSeconds, asaltoActual: 1);
  }

  Future<void> decrease() async {
      // Asynchronous function that decreases the timer state, plays different sounds based on the state, and handles state updates accordingly.
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
      state = state.copyWith(seconds: roundConfiguration.totalSeconds, isSecondBreak: true);
    }
    print("Antes de siguient asalto");
    if (state.seconds == 0 && state.isRunning && state.isSecondBreak) {
      siguienteAsalto();
    }
  }

  void siguienteAsalto() {
      // Increments the current round by 1 and checks if the new round is within the total number of rounds. If it is, updates the state with the new round information.
    int asalto = state.asaltoActual + 1;
    if (asalto <= roundConfiguration.totalRounds) {
      state = state.copyWith(
          seconds: roundConfiguration.totalSeconds, asaltoActual: asalto, isSecondBreak: false);
      print("Siguient Asalto");
    }
  }

  Future<void> playCampana(int second, String fileSound) async {
    // Asynchronous function that plays a sound if the given second is equal to 11.Q
    print("Tiempo: ${second}");
    if (second == 11) {
      await player.play(AssetSource(fileSound));
    }
  }

  bool get isActivate => state.isRunning; // Getter method that returns the state of the timer activation.

  bool get isBreak => state.isSecondBreak; // Getter method that returns the state of the timer break.
}
