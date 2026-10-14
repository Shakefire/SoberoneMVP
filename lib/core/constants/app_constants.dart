class AppConstants {
  static const String appName = 'SoberOne';
  static const String tagline = 'One day at a time, every second counts';

  // Common Addiction Types / Goals
  static const List<String> habitCategories = [
    'Alcohol',
    'Smoking / Vaping',
    'Gambling',
    'Sugar / Junk Food',
    'Social Media',
    'Cannabis',
    'Custom Habit',
  ];

  // Common Triggers
  static const List<String> triggerOptions = [
    'Stress',
    'Social Gathering',
    'Boredom',
    'Fatigue / Exhaustion',
    'Loneliness',
    'Anger / Frustration',
    'Celebration',
    'Habit / Routine',
    'Anxiety',
  ];

  // Centralized Crisis Contact — exactly ONE verified national helpline.
  // SAFETY RULE: This constant may ONLY be displayed on the Support page.
  // Do NOT reference this from onboarding, progress, community, or craving-tracker screens.
  static const Map<String, String> nationalHelpline = {
    'title': 'SAMHSA National Helpline',
    'number': '1-800-662-4357',
    'description': 'Free, confidential, 24/7 treatment referral & information.',
  };
}
