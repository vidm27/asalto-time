class RoundCounter {
  final int seconds;
  final bool isRunning;
  final bool isSecondBreak;
  final int asaltoActual;
  final int secondsReset;

  RoundCounter(
      {this.seconds = 15,
        this.secondsReset = 15,
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