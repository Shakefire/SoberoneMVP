class SobrietyProfile {
  final String habitName;
  final DateTime quitDate;
  final double dailyCost;
  final double dailyHoursSaved;
  final String reasonWhy;
  final bool hasPledgedToday;
  final DateTime? lastPledgeDate;

  SobrietyProfile({
    required this.habitName,
    required this.quitDate,
    this.dailyCost = 15.0,
    this.dailyHoursSaved = 2.0,
    this.reasonWhy = 'To regain focus, improve health, and show up for the people I love.',
    this.hasPledgedToday = false,
    this.lastPledgeDate,
  });

  Duration get elapsedDuration => DateTime.now().difference(quitDate);

  List<String> get substances => [habitName];

  int get elapsedDays => elapsedDuration.inDays;

  double get totalMoneySaved {
    final daysFraction = elapsedDuration.inSeconds / 86400.0;
    return (daysFraction * dailyCost).clamp(0.0, double.infinity);
  }

  double get totalHoursSaved {
    final daysFraction = elapsedDuration.inSeconds / 86400.0;
    return (daysFraction * dailyHoursSaved).clamp(0.0, double.infinity);
  }

  SobrietyProfile copyWith({
    String? habitName,
    DateTime? quitDate,
    double? dailyCost,
    double? dailyHoursSaved,
    String? reasonWhy,
    bool? hasPledgedToday,
    DateTime? lastPledgeDate,
  }) {
    return SobrietyProfile(
      habitName: habitName ?? this.habitName,
      quitDate: quitDate ?? this.quitDate,
      dailyCost: dailyCost ?? this.dailyCost,
      dailyHoursSaved: dailyHoursSaved ?? this.dailyHoursSaved,
      reasonWhy: reasonWhy ?? this.reasonWhy,
      hasPledgedToday: hasPledgedToday ?? this.hasPledgedToday,
      lastPledgeDate: lastPledgeDate ?? this.lastPledgeDate,
    );
  }
}
