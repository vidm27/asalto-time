import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(120);

  late Timer _timer;
  bool isActivateTime = false;

  void startTimer() {
    if (isActivateTime == false) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        state--;
        if(state == 0){
          _timer.cancel();
          print("Llegamos a Cero");
        }
      });
      isActivateTime = true;
    }
  }

  void stopTimer() {
    if (isActivateTime) {
      _timer.cancel();
      isActivateTime=false;
      state = 0;
    }
  }

  void resetTimer() {
    state = 120;
  }

  bool isActivate(){
    return isActivateTime;
  }
}