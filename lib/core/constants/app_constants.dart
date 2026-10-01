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

  // Emergency Helplines / Resources
  static const List<Map<String, String>> emergencyHotlines = [
    {
      'title': 'SAMHSA National Helpline',
      'number': '1-800-662-4357',
      'description': 'Free, confidential, 24/7 treatment referral & information',
    },
    {
      'title': 'Suicide & Crisis Lifeline',
      'number': '988',
      'description': 'Free 24/7 support for mental distress or crisis',
    },
    {
      'title': 'Crisis Text Line',
      'number': 'Text HOME to 741741',
      'description': 'Free 24/7 crisis support via SMS text',
    },
  ];
}
