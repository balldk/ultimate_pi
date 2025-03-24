class Entered {
  final String streakId;
  final bool isCorrect;
  final DateTime timeNow;
  final DateTime? inputTime;
  final String value;
  final String correctValue;
  final int position;
  bool isOnStreak = false;

  Entered({
    required this.streakId,
    required this.isCorrect,
    required this.timeNow,
    required this.inputTime,
    required this.value,
    required this.correctValue,
    required this.position,
  });

  void setIsOnStreak(bool value) {
    isOnStreak = value;
  }

  bool isBefore(DateTime time) {
    return inputTime?.isBefore(time) == true;
  }

  bool isAfter(DateTime time) {
    return inputTime?.isAfter(time) == true;
  }

  bool isSameStreakId(Entered entered) {
    return streakId == entered.streakId;
  }
}
