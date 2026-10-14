import 'package:flutter/foundation.dart';

enum SoberGoal { quitCompletely, reduce, quitGradually, explore }

extension SoberGoalLabel on SoberGoal {
  String get label {
    switch (this) {
      case SoberGoal.quitCompletely:
        return 'Quit completely';
      case SoberGoal.reduce:
        return 'Reduce';
      case SoberGoal.quitGradually:
        return 'Quit gradually';
      case SoberGoal.explore:
        return 'Explore';
    }
  }

  String get description {
    switch (this) {
      case SoberGoal.quitCompletely:
        return 'Total abstinence and freedom';
      case SoberGoal.reduce:
        return 'Cut down usage to a healthier level';
      case SoberGoal.quitGradually:
        return 'Step-by-step reduction towards zero';
      case SoberGoal.explore:
        return 'Understand my relationship with it first';
    }
  }
}

enum UseFrequency { everyday, mostDays, someDays, occasionally }

extension UseFrequencyLabel on UseFrequency {
  String get label {
    switch (this) {
      case UseFrequency.everyday:
        return 'Every day';
      case UseFrequency.mostDays:
        return 'Most days';
      case UseFrequency.someDays:
        return 'Some days';
      case UseFrequency.occasionally:
        return 'Occasionally';
    }
  }

  String get description {
    switch (this) {
      case UseFrequency.everyday:
        return 'Daily routine or multiple times a day';
      case UseFrequency.mostDays:
        return '4 to 6 days a week';
      case UseFrequency.someDays:
        return '1 to 3 days a week';
      case UseFrequency.occasionally:
        return 'A few times a month or during social events';
    }
  }
}

enum StartWhen { today, alreadyStarted, chooseDate, notSure }

extension StartWhenLabel on StartWhen {
  String get label {
    switch (this) {
      case StartWhen.today:
        return 'Today';
      case StartWhen.alreadyStarted:
        return 'Already started';
      case StartWhen.chooseDate:
        return 'Choose a date';
      case StartWhen.notSure:
        return 'Not sure';
    }
  }

  String get description {
    switch (this) {
      case StartWhen.today:
        return 'Day one begins right now';
      case StartWhen.alreadyStarted:
        return "I'm already on my sobriety journey";
      case StartWhen.chooseDate:
        return 'Pick my exact milestone starting date';
      case StartWhen.notSure:
        return "I'm taking it one moment at a time";
    }
  }
}

enum LifeGoal {
  mentalWellbeing,
  physicalHealth,
  relationships,
  sleepEnergy,
  stressManagement,
  productivity,
  confidence,
  money,
  spiritualWellbeing,
  hobbies,
}

extension LifeGoalLabel on LifeGoal {
  String get label {
    switch (this) {
      case LifeGoal.mentalWellbeing:
        return 'Mental wellbeing';
      case LifeGoal.physicalHealth:
        return 'Physical health';
      case LifeGoal.relationships:
        return 'Relationships';
      case LifeGoal.sleepEnergy:
        return 'Sleep & energy';
      case LifeGoal.stressManagement:
        return 'Stress management';
      case LifeGoal.productivity:
        return 'Productivity';
      case LifeGoal.confidence:
        return 'Confidence';
      case LifeGoal.money:
        return 'Money & savings';
      case LifeGoal.spiritualWellbeing:
        return 'Spiritual wellbeing';
      case LifeGoal.hobbies:
        return 'Hobbies & interests';
    }
  }

  String get emoji {
    switch (this) {
      case LifeGoal.mentalWellbeing:
        return '🧠';
      case LifeGoal.physicalHealth:
        return '💪';
      case LifeGoal.relationships:
        return '❤️';
      case LifeGoal.sleepEnergy:
        return '🌙';
      case LifeGoal.stressManagement:
        return '🧘';
      case LifeGoal.productivity:
        return '⚡';
      case LifeGoal.confidence:
        return '✨';
      case LifeGoal.money:
        return '💰';
      case LifeGoal.spiritualWellbeing:
        return '🕊️';
      case LifeGoal.hobbies:
        return '🎨';
    }
  }
}

enum SupportStyle { private, someoneTrust, recoveryCommunity, notSure }

extension SupportStyleLabel on SupportStyle {
  String get label {
    switch (this) {
      case SupportStyle.private:
        return 'Privately';
      case SupportStyle.someoneTrust:
        return 'With someone I trust';
      case SupportStyle.recoveryCommunity:
        return 'Recovery community';
      case SupportStyle.notSure:
        return 'Not sure yet';
    }
  }

  String get description {
    switch (this) {
      case SupportStyle.private:
        return 'Just me and the app — completely discreet';
      case SupportStyle.someoneTrust:
        return 'Partner, close friend, or family member';
      case SupportStyle.recoveryCommunity:
        return 'Connect and share with peers in recovery';
      case SupportStyle.notSure:
        return 'You can change this anytime in settings';
    }
  }
}

enum AgeRange { a18to24, a25to34, a35to44, a45to54, a55plus }

extension AgeRangeLabel on AgeRange {
  String get label {
    switch (this) {
      case AgeRange.a18to24:
        return '18–24';
      case AgeRange.a25to34:
        return '25–34';
      case AgeRange.a35to44:
        return '35–44';
      case AgeRange.a45to54:
        return '45–54';
      case AgeRange.a55plus:
        return '55+';
    }
  }
}

class OnboardingState {
  final Set<String> selectedSubstances;
  final SoberGoal? goal;
  final UseFrequency? frequency;
  final StartWhen? startWhen;
  final DateTime? customStartDate;
  final Set<LifeGoal> lifeGoals;
  final SupportStyle? supportStyle;
  final AgeRange? ageRange;
  final String country;
  final String region;
  final bool agreedToTerms;
  final bool consentedToProcessing;

  const OnboardingState({
    this.selectedSubstances = const {},
    this.goal,
    this.frequency,
    this.startWhen,
    this.customStartDate,
    this.lifeGoals = const {},
    this.supportStyle,
    this.ageRange,
    this.country = 'Nigeria',
    this.region = '',
    this.agreedToTerms = false,
    this.consentedToProcessing = false,
  });

  OnboardingState copyWith({
    Set<String>? selectedSubstances,
    SoberGoal? goal,
    UseFrequency? frequency,
    StartWhen? startWhen,
    DateTime? customStartDate,
    Set<LifeGoal>? lifeGoals,
    SupportStyle? supportStyle,
    AgeRange? ageRange,
    String? country,
    String? region,
    bool? agreedToTerms,
    bool? consentedToProcessing,
  }) {
    return OnboardingState(
      selectedSubstances: selectedSubstances ?? this.selectedSubstances,
      goal: goal ?? this.goal,
      frequency: frequency ?? this.frequency,
      startWhen: startWhen ?? this.startWhen,
      customStartDate: customStartDate ?? this.customStartDate,
      lifeGoals: lifeGoals ?? this.lifeGoals,
      supportStyle: supportStyle ?? this.supportStyle,
      ageRange: ageRange ?? this.ageRange,
      country: country ?? this.country,
      region: region ?? this.region,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      consentedToProcessing:
          consentedToProcessing ?? this.consentedToProcessing,
    );
  }
}

class OnboardingProvider extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();
  int _currentStep = 0; // 0 to 6 (7 total conversational steps)
  bool _isMovingForward = true;

  OnboardingState get state => _state;
  int get currentStep => _currentStep;
  bool get isMovingForward => _isMovingForward;
  static const int totalSteps = 7;

  static const substances = [
    'Alcohol',
    'Smoking / nicotine',
    'Cannabis',
    'Prescription medication',
    'Opioids',
    'Cocaine / crack',
    'Stimulants',
    'Other',
  ];

  static const Map<String, String> substanceEmojis = {
    'Alcohol': '🍷',
    'Smoking / nicotine': '🚬',
    'Cannabis': '🌿',
    'Prescription medication': '💊',
    'Opioids': '💉',
    'Cocaine / crack': '❄️',
    'Stimulants': '⚡',
    'Other': '🎯',
  };

  static String _cleanSubstanceName(String s) {
    if (s == 'Smoking / nicotine') return 'nicotine';
    if (s == 'Other') return 'other substances';
    return s.toLowerCase();
  }

  String get formattedSelectedSubstances {
    final list = _state.selectedSubstances.map(_cleanSubstanceName).toList();
    if (list.isEmpty) return 'substances';
    if (list.length == 1) return list.first;
    if (list.length == 2) return '${list[0]} and ${list[1]}';
    final allExceptLast = list.sublist(0, list.length - 1).join(', ');
    return '$allExceptLast, and ${list.last}';
  }

  String get frequencyQuestion {
    final formatted = formattedSelectedSubstances;
    return 'How often do you take $formatted?';
  }

  void toggleSubstance(String substance) {
    final updated = Set<String>.from(_state.selectedSubstances);
    if (updated.contains(substance)) {
      updated.remove(substance);
    } else {
      updated.add(substance);
    }
    _state = _state.copyWith(selectedSubstances: updated);
    notifyListeners();
  }

  void setGoal(SoberGoal goal) {
    _state = _state.copyWith(goal: goal);
    notifyListeners();
  }

  void setFrequency(UseFrequency freq) {
    _state = _state.copyWith(frequency: freq);
    notifyListeners();
  }

  void setStartWhen(StartWhen when) {
    _state = _state.copyWith(startWhen: when);
    notifyListeners();
  }

  void setCustomStartDate(DateTime date) {
    _state = _state.copyWith(customStartDate: date);
    notifyListeners();
  }

  void toggleLifeGoal(LifeGoal goal) {
    final updated = Set<LifeGoal>.from(_state.lifeGoals);
    if (updated.contains(goal)) {
      updated.remove(goal);
    } else if (updated.length < 3) {
      updated.add(goal);
    }
    _state = _state.copyWith(lifeGoals: updated);
    notifyListeners();
  }

  void setSupportStyle(SupportStyle style) {
    _state = _state.copyWith(supportStyle: style);
    notifyListeners();
  }

  void setAgeRange(AgeRange age) {
    _state = _state.copyWith(ageRange: age);
    notifyListeners();
  }

  void setCountry(String country) {
    _state = _state.copyWith(country: country);
    notifyListeners();
  }

  void setRegion(String region) {
    _state = _state.copyWith(region: region);
    notifyListeners();
  }

  void setAgreedToTerms(bool value) {
    _state = _state.copyWith(agreedToTerms: value);
    notifyListeners();
  }

  void setConsentedToProcessing(bool value) {
    _state = _state.copyWith(consentedToProcessing: value);
    notifyListeners();
  }

  // Step readiness checks
  bool get canProceedStep0 => _state.selectedSubstances.isNotEmpty;
  bool get canProceedStep1 => _state.goal != null;
  bool get canProceedStep2 => _state.frequency != null;
  bool get canProceedStep3 => _state.startWhen != null;
  bool get canProceedStep4 => _state.lifeGoals.isNotEmpty;
  bool get canProceedStep5 => _state.supportStyle != null;
  bool get canProceedStep6 => _state.ageRange != null;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _isMovingForward = true;
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _isMovingForward = false;
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _isMovingForward = step >= _currentStep;
    _currentStep = step.clamp(0, totalSteps - 1);
    notifyListeners();
  }
}
