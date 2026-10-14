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
          colors: [Color(0xFF0C3C60), Color(0xFF06213A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C3C60).withValues(alpha: 0.25),
            blurRadius: 24,
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
              color: AppColors.accentCyan.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.accentCyan,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Free from ${profile.habitName}',
                  style: const TextStyle(
                    color: Color(0xFFE0F7FA),
                    fontWeight: FontWeight.w700,
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
              fontSize: 76,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -2,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'DAYS SOBER',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF94A3B8),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 24),

          // Hours, Minutes, Seconds ticker
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
              color: Color(0xFF94A3B8),
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
            color: highlight ? AppColors.accentCyan : Colors.white,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCBD5E1),
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
      color: Colors.white24,
    );
  }
}
