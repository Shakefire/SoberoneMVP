import 'package:flutter/material.dart';

class Milestone {
  final String id;
  final String title;
  final String description;
  final Duration targetDuration;
  final IconData icon;
  final Color accentColor;

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDuration,
    required this.icon,
    this.accentColor = const Color(0xFF00B894),
  });

  bool isUnlocked(Duration elapsed) => elapsed >= targetDuration;

  double progress(Duration elapsed) {
    if (isUnlocked(elapsed)) return 1.0;
    if (elapsed.isNegative) return 0.0;
    final totalMs = targetDuration.inMilliseconds;
    if (totalMs == 0) return 1.0;
    return (elapsed.inMilliseconds / totalMs).clamp(0.0, 1.0);
  }

  static List<Milestone> get defaultMilestones => [
    const Milestone(
      id: '24_hours',
      title: 'First 24 Hours',
      description: 'The foundation of your journey. You took the boldest step.',
      targetDuration: Duration(hours: 24),
      icon: Icons.wb_sunny_rounded,
      accentColor: Color(0xFFF39C12),
    ),
    const Milestone(
      id: '3_days',
      title: '72 Hours Resilient',
      description: 'Acute withdrawal symptoms begin to subside. Your body is clearing toxins.',
      targetDuration: Duration(days: 3),
      icon: Icons.shield_rounded,
      accentColor: Color(0xFF00CEC9),
    ),
    const Milestone(
      id: '1_week',
      title: '1 Week Victorious',
      description: 'A full cycle completed. Natural sleep patterns start recovering.',
      targetDuration: Duration(days: 7),
      icon: Icons.military_tech_rounded,
      accentColor: Color(0xFF00B894),
    ),
    const Milestone(
      id: '2_weeks',
      title: 'Fortnight of Clarity',
      description: 'Energy levels stabilize and mental fog begins lifting.',
      targetDuration: Duration(days: 14),
      icon: Icons.psychology_rounded,
      accentColor: Color(0xFF0984E3),
    ),
    const Milestone(
      id: '1_month',
      title: '1 Month Champion',
      description: '30 consecutive days! Cellular repair and emotional balance in full swing.',
      targetDuration: Duration(days: 30),
      icon: Icons.workspace_premium_rounded,
      accentColor: Color(0xFF6C5CE7),
    ),
    const Milestone(
      id: '60_days',
      title: '60 Days Momentum',
      description: 'New neural pathways and healthy coping routines are firmly established.',
      targetDuration: Duration(days: 60),
      icon: Icons.diamond_rounded,
      accentColor: Color(0xFFE84393),
    ),
    const Milestone(
      id: '90_days',
      title: '90 Days Reborn',
      description: 'A major milestone in recovery psychology. Cravings drop dramatically.',
      targetDuration: Duration(days: 90),
      icon: Icons.star_rounded,
      accentColor: Color(0xFFFFA502),
    ),
    const Milestone(
      id: '6_months',
      title: 'Half a Year Sovereign',
      description: '6 solid months. Incredible transformation of mind, health, and spirit.',
      targetDuration: Duration(days: 182),
      icon: Icons.emoji_events_rounded,
      accentColor: Color(0xFFFF4757),
    ),
    const Milestone(
      id: '1_year',
      title: '1 Year Legend',
      description: '365 days of freedom. You faced every season and emerged triumphant.',
      targetDuration: Duration(days: 365),
      icon: Icons.military_tech_outlined,
      accentColor: Color(0xFF2ED573),
    ),
  ];
}
