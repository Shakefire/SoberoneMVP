import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../models/sobriety_profile.dart';

class CounterCard extends StatelessWidget {
  final SobrietyProfile profile;

  const CounterCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final breakdown = TimeFormatter.getElapsedBreakdown(profile.quitDate);
    final days = breakdown['days'] ?? 0;
    final hours = breakdown['hours'] ?? 0;
    final minutes = breakdown['minutes'] ?? 0;
    final seconds = breakdown['seconds'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF162544), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withAlpha(90)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.primaryLight,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Free from ${profile.habitName}',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Big Days Counter
          Text(
            '$days',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -2,
              height: 1.0,
            ),
          ),
          const Text(
            'DAYS SOBER',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondaryDark,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 24),

          // Hours, Minutes, Seconds ticker
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withAlpha(120),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeUnit(
                  hours.toString().padLeft(2, '0'),
                  'HOURS',
                ),
                _buildDivider(),
                _buildTimeUnit(
                  minutes.toString().padLeft(2, '0'),
                  'MINS',
                ),
                _buildDivider(),
                _buildTimeUnit(
                  seconds.toString().padLeft(2, '0'),
                  'SECS',
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Started on subtitle
          Text(
            'Started ${TimeFormatter.formatDateTime(profile.quitDate)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label, {bool highlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: highlight ? AppColors.primaryLight : Colors.white,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textMutedDark,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white12,
    );
  }
}
