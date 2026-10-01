import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/milestone.dart';
import '../../providers/sobriety_provider.dart';

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final elapsed = sobriety.profile.elapsedDuration;
    final milestones = Milestone.defaultMilestones;
    final unlockedCount = milestones.where((m) => m.isUnlocked(elapsed)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones & Badges', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // Banner summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF1E272E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.warning.withAlpha(80)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.warning,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlockedCount of ${milestones.length} Badges Claimed',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Every single hour clean is proof of your courage.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Milestone Cards Grid / List
          ...milestones.map((milestone) {
            final isUnlocked = milestone.isUnlocked(elapsed);
            final progress = milestone.progress(elapsed);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.surfaceDark : AppColors.surfaceDark.withAlpha(120),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked ? milestone.accentColor.withAlpha(100) : AppColors.borderDark,
                  width: isUnlocked ? 1.5 : 1,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: milestone.accentColor.withAlpha(20),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Badge Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? milestone.accentColor.withAlpha(35)
                          : Colors.white.withAlpha(10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isUnlocked ? milestone.accentColor : Colors.white12,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isUnlocked ? milestone.icon : Icons.lock_outline_rounded,
                      color: isUnlocked ? milestone.accentColor : AppColors.textMutedDark,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Texts & Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              milestone.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.white : AppColors.textSecondaryDark,
                              ),
                            ),
                            if (isUnlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Claimed',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMutedDark,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          milestone.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMutedDark,
                            height: 1.3,
                          ),
                        ),
                        if (!isUnlocked) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(milestone.accentColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
