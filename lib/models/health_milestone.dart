import 'package:flutter/material.dart';

class HealthMilestone {
  final String title;
  final Duration durationRequired;
  final String category;
  final String description;
  final IconData icon;

  const HealthMilestone({
    required this.title,
    required this.durationRequired,
    required this.category,
    required this.description,
    required this.icon,
  });

  bool isComplete(Duration elapsed) => elapsed >= durationRequired;

  double progress(Duration elapsed) {
    if (isComplete(elapsed)) return 1.0;
    if (elapsed.isNegative) return 0.0;
    return (elapsed.inSeconds / durationRequired.inSeconds).clamp(0.0, 1.0);
  }

  static List<HealthMilestone> get defaultHealthMilestones => [
    const HealthMilestone(
      title: 'Blood Pressure & Heart Rate',
      durationRequired: Duration(hours: 8),
      category: 'Cardiovascular',
      description: 'Blood pressure and pulse rate drop back to normal baseline resting levels.',
      icon: Icons.favorite_rounded,
    ),
    const HealthMilestone(
      title: 'Complete Detoxification',
      durationRequired: Duration(hours: 24),
      category: 'Metabolic',
      description: 'Your bloodstream has cleared the primary toxic compounds; kidneys working efficiently.',
      icon: Icons.water_drop_rounded,
    ),
    const HealthMilestone(
      title: 'Sensory Regeneration',
      durationRequired: Duration(hours: 48),
      category: 'Nervous System',
      description: 'Nerve endings start regenerating. Taste and smell senses noticeably sharpen.',
      icon: Icons.restaurant_rounded,
    ),
    const HealthMilestone(
      title: 'Sleep Architecture Repair',
      durationRequired: Duration(days: 7),
      category: 'Brain & Sleep',
      description: 'REM sleep cycles increase, leading to deeper restorative sleep and morning clarity.',
      icon: Icons.bedtime_rounded,
    ),
    const HealthMilestone(
      title: 'Hydration & Skin Elasticity',
      durationRequired: Duration(days: 14),
      category: 'Dermatological',
      description: 'Skin barrier retains moisture better; reduced inflammation, redness, and puffiness.',
      icon: Icons.face_rounded,
    ),
    const HealthMilestone(
      title: 'Liver Function & Digestion',
      durationRequired: Duration(days: 30),
      category: 'Internal Organs',
      description: 'Hepatic fat levels drop by up to 20%, significantly improving metabolic efficiency.',
      icon: Icons.healing_rounded,
    ),
    const HealthMilestone(
      title: 'Dopamine Homeostasis',
      durationRequired: Duration(days: 90),
      category: 'Neuroscience',
      description: 'Brain dopamine receptors normalize, restoring natural pleasure from daily life.',
      icon: Icons.insights_rounded,
    ),
  ];
}
