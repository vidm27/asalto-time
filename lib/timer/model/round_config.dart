class RoundConfig {
  final int totalRounds;
  final int totalSeconds;
  final int secondsBreak;

  RoundConfig(
      {required this.totalRounds,
      required this.totalSeconds,
      required this.secondsBreak});

  RoundConfig copyWith(
      {int? totalRounds, int? totalSeconds, int? secondsBreak}) {
    return RoundConfig(
        totalRounds: totalRounds ?? this.totalRounds,
        totalSeconds: totalSeconds ?? this.totalSeconds,
        secondsBreak: secondsBreak ?? this.secondsBreak);
  }
}
