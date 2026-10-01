import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/milestone.dart';

class NextMilestoneCard extends StatelessWidget {
  final Milestone? milestone;
  final Duration elapsed;

  const NextMilestoneCard({
    super.key,
    required this.milestone,
    required this.elapsed,
  });

  @override
  Widget build(BuildContext context) {
    if (milestone == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: const Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: AppColors.warning, size: 32),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'All major core milestones achieved! You are a true inspiration.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final progress = milestone!.progress(elapsed);
    final remaining = milestone!.targetDuration - elapsed;
    final remainingDays = remaining.inDays;
    final remainingHours = remaining.inHours % 24;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: milestone!.accentColor.withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  milestone!.icon,
                  color: milestone!.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Milestone',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      milestone!.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: milestone!.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(milestone!.accentColor),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                milestone!.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMutedDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                remainingDays > 0
                    ? '$remainingDays d ${remainingHours}h to go'
                    : '$remainingHours hours to go',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
