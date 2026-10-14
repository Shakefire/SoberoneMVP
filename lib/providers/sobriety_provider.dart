import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sobriety_profile.dart';
import '../models/milestone.dart';

class SobrietyProvider extends ChangeNotifier {
  late SobrietyProfile _profile;
  Timer? _timer;
  bool _isInitialized = false;

  SobrietyProfile get profile => _profile;
  bool get isInitialized => _isInitialized;

  SobrietyProvider() {
    // Default initial profile: 14 days ago for a rich immediate preview experience
    final defaultStartDate = DateTime.now().subtract(
      const Duration(days: 14, hours: 8, minutes: 22, seconds: 15),
    );

    _profile = SobrietyProfile(
      habitName: 'Alcohol',
      quitDate: defaultStartDate,
      dailyCost: 15.0,
      dailyHoursSaved: 2.0,
      reasonWhy: 'Clear mind, revitalized health, deeper presence with family.',
      hasPledgedToday: true,
      lastPledgeDate: DateTime.now(),
    );

    _startTimer();
    _loadFromPrefs();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habit = prefs.getString('habit_name');
      final quitDateMillis = prefs.getInt('quit_date_millis');
      final cost = prefs.getDouble('daily_cost');
      final hours = prefs.getDouble('daily_hours');
      final reason = prefs.getString('reason_why');
      final lastPledgeMillis = prefs.getInt('last_pledge_millis');

      DateTime? lastPledgeDate;
      bool hasPledged = false;
      if (lastPledgeMillis != null) {
        lastPledgeDate = DateTime.fromMillisecondsSinceEpoch(lastPledgeMillis);
        final now = DateTime.now();
        hasPledged = lastPledgeDate.year == now.year &&
            lastPledgeDate.month == now.month &&
            lastPledgeDate.day == now.day;
      }

      if (habit != null && quitDateMillis != null) {
        _profile = SobrietyProfile(
          habitName: habit,
          quitDate: DateTime.fromMillisecondsSinceEpoch(quitDateMillis),
          dailyCost: cost ?? 15.0,
          dailyHoursSaved: hours ?? 2.0,
          reasonWhy: reason ?? _profile.reasonWhy,
          hasPledgedToday: hasPledged,
          lastPledgeDate: lastPledgeDate,
        );
      }
    } catch (e) {
      debugPrint('Error loading prefs: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('habit_name', _profile.habitName);
      await prefs.setInt('quit_date_millis', _profile.quitDate.millisecondsSinceEpoch);
      await prefs.setDouble('daily_cost', _profile.dailyCost);
      await prefs.setDouble('daily_hours', _profile.dailyHoursSaved);
      await prefs.setString('reason_why', _profile.reasonWhy);
      if (_profile.lastPledgeDate != null) {
        await prefs.setInt('last_pledge_millis', _profile.lastPledgeDate!.millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint('Error saving prefs: $e');
    }
  }

  void updateProfile({
    String? habitName,
    DateTime? quitDate,
    double? dailyCost,
    double? dailyHoursSaved,
    String? reasonWhy,
  }) {
    _profile = _profile.copyWith(
      habitName: habitName,
      quitDate: quitDate,
      dailyCost: dailyCost,
      dailyHoursSaved: dailyHoursSaved,
      reasonWhy: reasonWhy,
    );
    notifyListeners();
    _saveToPrefs();
  }

  void resetStreak() {
    _profile = _profile.copyWith(
      quitDate: DateTime.now(),
      hasPledgedToday: false,
    );
    notifyListeners();
    _saveToPrefs();
  }

  void togglePledgeToday() {
    final now = DateTime.now();
    final newPledged = !_profile.hasPledgedToday;
    _profile = _profile.copyWith(
      hasPledgedToday: newPledged,
      lastPledgeDate: newPledged ? now : null,
    );
    notifyListeners();
    _saveToPrefs();
  }

  Milestone? get nextMilestone {
    final elapsed = _profile.elapsedDuration;
    for (final milestone in Milestone.defaultMilestones) {
      if (!milestone.isUnlocked(elapsed)) {
        return milestone;
      }
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────
  // Professional Certification & Rewards State
  // ─────────────────────────────────────────────────────────────
  bool _isPledgedForCertification = false;
  String _pledgedMilestone = 'Day 90';
  String? _beforePhotoPath;
  DateTime? _pledgeDate;
  bool _isCertificationReady = false;
  bool _isQuizCompleted = false;
  String? _afterPhotoPath;
  bool _isAssessmentPassed = false;
  final List<RewardApplication> _rewardApplications = [
    const RewardApplication(
      id: 'app_1',
      grantTitle: 'Small Business Capital',
      amount: '₦500,000',
      submissionDate: 'Oct 01, 2026',
      status: 'Under Review',
    ),
  ];

  bool get isPledgedForCertification => _isPledgedForCertification;
  String get pledgedMilestone => _pledgedMilestone;
  String? get beforePhotoPath => _beforePhotoPath;
  DateTime? get pledgeDate => _pledgeDate;
  bool get isCertificationReady =>
      _isCertificationReady || (_isPledgedForCertification && _profile.elapsedDays >= 90);
  bool get isQuizCompleted => _isQuizCompleted;
  String? get afterPhotoPath => _afterPhotoPath;
  bool get isAssessmentPassed => _isAssessmentPassed;
  List<RewardApplication> get rewardApplications =>
      List.unmodifiable(_rewardApplications);

  void pledgeCertification({
    required String milestone,
    required String photoPath,
  }) {
    _isPledgedForCertification = true;
    _pledgedMilestone = milestone;
    _beforePhotoPath = photoPath;
    _pledgeDate = DateTime.now();
    // For immediate rich preview/testing convenience, enable certification ready
    _isCertificationReady = true;
    notifyListeners();
    _saveToPrefs();
  }

  void setCertificationReady(bool ready) {
    _isCertificationReady = ready;
    notifyListeners();
  }

  void completeQuiz({required String afterPhotoPath}) {
    _isQuizCompleted = true;
    _afterPhotoPath = afterPhotoPath;
    notifyListeners();
    _saveToPrefs();
  }

  void passAssessment() {
    _isAssessmentPassed = true;
    notifyListeners();
    _saveToPrefs();
  }

  void submitRewardApplication({
    required String grantTitle,
    required String amount,
  }) {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
    _rewardApplications.insert(
      0,
      RewardApplication(
        id: 'app_${DateTime.now().millisecondsSinceEpoch}',
        grantTitle: grantTitle,
        amount: amount,
        submissionDate: dateStr,
        status: 'Pending',
      ),
    );
    notifyListeners();
  }
}

class RewardApplication {
  final String id;
  final String grantTitle;
  final String amount;
  final String submissionDate;
  final String status; // 'Pending', 'Under Review', 'Approved'

  const RewardApplication({
    required this.id,
    required this.grantTitle,
    required this.amount,
    required this.submissionDate,
    required this.status,
  });
}
