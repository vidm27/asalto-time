import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asalto_time/timer/model/round_model.dart';

// final roundTimerNotifierProvider = StateNotifierProvider();

class RoundNotifier extends StateNotifier<RoundModel> {
  RoundNotifier() : super(RoundModel(timeRound: 120, currentRound: 1));
}

class RoundCounter {
  final int seconds;
  final bool isRunning;
  final bool isSecondBreak;
  final int asaltoActual;
  final int secondsReset;

  RoundCounter(
      {this.seconds = 5,
      this.secondsReset = 5,
      this.isRunning = false,
      this.isSecondBreak = false,
      this.asaltoActual = 1});

  RoundCounter copyWith(
          {int? seconds,
          int? secondsReset,
          bool? isRunning,
          bool? isSecondBreak,
          int? asaltoActual}) =>
      RoundCounter(
          seconds: seconds ?? this.seconds,
          secondsReset: secondsReset ?? this.secondsReset,
          isRunning: isRunning ?? this.isRunning,
          isSecondBreak: isSecondBreak ?? this.isSecondBreak,
          asaltoActual: asaltoActual ?? this.asaltoActual);
}

final timerProvider = StateNotifierProvider<TimerNotifier, RoundCounter>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<RoundCounter> {
  TimerNotifier() : super(RoundCounter(seconds: 5));

  late Timer _timer;
  bool isActivateTime = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      decrease();
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
    state = state.copyWith(seconds: 5, asaltoActual: 2);
  }

  void decrease() {
    if (state.seconds > 0) {
      int second = state.seconds;
      second--;
      state = state.copyWith(seconds: second);
    }
    if (state.seconds == 0 && state.isRunning && !state.isSecondBreak) {
      state = state.copyWith(seconds: state.secondsReset, isSecondBreak: true);
    }
    print("Antes de siguient asalto");
    if (state.seconds == 0 && state.isRunning && state.isSecondBreak) {
      siguienteAsalto();
    }
  }

  void siguienteAsalto() {
    int asalto = state.asaltoActual + 1;
    if (asalto <= 2) {
      state = state.copyWith(
          seconds: 5, asaltoActual: asalto, isSecondBreak: false);
      print("Siguient Asalto");
    }
  }

  bool get isActivate => state.isRunning;

  bool get isBreak => state.isSecondBreak;
}
