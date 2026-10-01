import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/check_in.dart';

class CheckInProvider extends ChangeNotifier {
  final List<CheckInEntry> _entries = [];

  List<CheckInEntry> get entries => List.unmodifiable(_entries);

  CheckInProvider() {
    _loadEntries();
  }

  CheckInEntry? get todayCheckIn {
    final now = DateTime.now();
    for (final e in _entries) {
      if (e.timestamp.year == now.year &&
          e.timestamp.month == now.month &&
          e.timestamp.day == now.day) {
        return e;
      }
    }
    return null;
  }

  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList('check_in_entries');
      if (rawList != null && rawList.isNotEmpty) {
        _entries.clear();
        for (final item in rawList) {
          final decoded = jsonDecode(item) as Map<String, dynamic>;
          _entries.add(CheckInEntry.fromJson(decoded));
        }
      } else {
        _seedMockEntries();
      }
    } catch (e) {
      _seedMockEntries();
    }
    _entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void _seedMockEntries() {
    _entries.clear();
    final now = DateTime.now();
    _entries.addAll([
      CheckInEntry(
        id: 'mock_today',
        timestamp: now.subtract(const Duration(hours: 3)),
        mood: MoodLevel.great,
        cravingLevel: 2,
        triggers: ['Social Gathering'],
        note: 'Attended a work dinner and stuck strictly to mocktails. Woke up feeling clear-headed and energized!',
        gratitude: 'Grateful for supportive friends and restful sleep.',
      ),
      CheckInEntry(
        id: 'mock_1',
        timestamp: now.subtract(const Duration(days: 1)),
        mood: MoodLevel.good,
        cravingLevel: 3,
        triggers: ['Stress'],
        note: 'A bit stressful at work today, took a 10 min walk instead of reaching for an old habit.',
        gratitude: 'Grateful for mindful pauses during stress.',
      ),
      CheckInEntry(
        id: 'mock_2',
        timestamp: now.subtract(const Duration(days: 2)),
        mood: MoodLevel.good,
        cravingLevel: 4,
        triggers: ['Boredom'],
        note: 'Felt an evening craving trigger during TV time. Practiced the 4-7-8 breathing.',
        gratitude: 'Grateful for breathing exercises that reset my nervous system.',
      ),
      CheckInEntry(
        id: 'mock_3',
        timestamp: now.subtract(const Duration(days: 3)),
        mood: MoodLevel.okay,
        cravingLevel: 6,
        triggers: ['Fatigue / Exhaustion', 'Stress'],
        note: 'Tough afternoon, but reminded myself why I started.',
        gratitude: 'Grateful for my resilience.',
      ),
      CheckInEntry(
        id: 'mock_4',
        timestamp: now.subtract(const Duration(days: 4)),
        mood: MoodLevel.great,
        cravingLevel: 1,
        triggers: [],
        note: 'Went for a 5k run in the morning. Natural endorphins felt incredible.',
        gratitude: 'Grateful for regaining physical strength.',
      ),
      CheckInEntry(
        id: 'mock_5',
        timestamp: now.subtract(const Duration(days: 5)),
        mood: MoodLevel.good,
        cravingLevel: 2,
        triggers: ['Social Gathering'],
        note: 'Smooth sailing, cravings are becoming much less frequent.',
        gratitude: 'Grateful for another clean day.',
      ),
      CheckInEntry(
        id: 'mock_6',
        timestamp: now.subtract(const Duration(days: 6)),
        mood: MoodLevel.great,
        cravingLevel: 2,
        triggers: [],
        note: 'Week milestone achieved! Celebrated with gourmet ice cream.',
        gratitude: 'Grateful for this app keeping me on track.',
      ),
    ]);
  }

  Future<void> addCheckIn({
    required MoodLevel mood,
    required int cravingLevel,
    required List<String> triggers,
    required String note,
    required String gratitude,
  }) async {
    final entry = CheckInEntry(
      id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      mood: mood,
      cravingLevel: cravingLevel,
      triggers: triggers,
      note: note,
      gratitude: gratitude,
    );

    _entries.removeWhere((e) {
      final now = DateTime.now();
      return e.timestamp.year == now.year &&
          e.timestamp.month == now.month &&
          e.timestamp.day == now.day;
    });

    _entries.insert(0, entry);
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _entries.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('check_in_entries', list);
    } catch (e) {
      debugPrint('Error saving check-ins: $e');
    }
  }

  double get averageCravingLast7Days {
    if (_entries.isEmpty) return 0;
    final recent = _entries.take(7);
    final sum = recent.fold<int>(0, (prev, e) => prev + e.cravingLevel);
    return sum / recent.length;
  }

  Map<String, int> get triggerFrequency {
    final map = <String, int>{};
    for (final e in _entries) {
      for (final t in e.triggers) {
        map[t] = (map[t] ?? 0) + 1;
      }
    }
    return map;
  }
}
