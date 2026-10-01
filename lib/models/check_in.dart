enum MoodLevel {
  great,
  good,
  okay,
  low,
  struggling,
}

extension MoodLevelExtension on MoodLevel {
  String get label {
    switch (this) {
      case MoodLevel.great:
        return 'Great';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.okay:
        return 'Neutral';
      case MoodLevel.low:
        return 'Low';
      case MoodLevel.struggling:
        return 'Struggling';
    }
  }

  String get emoji {
    switch (this) {
      case MoodLevel.great:
        return '🌟';
      case MoodLevel.good:
        return '😊';
      case MoodLevel.okay:
        return '😐';
      case MoodLevel.low:
        return '😔';
      case MoodLevel.struggling:
        return '⛈️';
    }
  }

  int get score {
    switch (this) {
      case MoodLevel.great:
        return 5;
      case MoodLevel.good:
        return 4;
      case MoodLevel.okay:
        return 3;
      case MoodLevel.low:
        return 2;
      case MoodLevel.struggling:
        return 1;
    }
  }
}

class CheckInEntry {
  final String id;
  final DateTime timestamp;
  final MoodLevel mood;
  final int cravingLevel; // 1 to 10
  final List<String> triggers;
  final String note;
  final String gratitude;

  CheckInEntry({
    required this.id,
    required this.timestamp,
    required this.mood,
    required this.cravingLevel,
    this.triggers = const [],
    this.note = '',
    this.gratitude = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'mood': mood.index,
      'cravingLevel': cravingLevel,
      'triggers': triggers,
      'note': note,
      'gratitude': gratitude,
    };
  }

  factory CheckInEntry.fromJson(Map<String, dynamic> json) {
    return CheckInEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mood: MoodLevel.values[json['mood'] as int],
      cravingLevel: json['cravingLevel'] as int,
      triggers: List<String>.from(json['triggers'] as List? ?? []),
      note: json['note'] as String? ?? '',
      gratitude: json['gratitude'] as String? ?? '',
    );
  }
}
