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
                colors: [Color(0xFF0C3C60), Color(0xFF06213A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0C3C60).withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.5),
                    ),
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
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Every single hour clean is proof of your courage.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE2E8F0),
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
                color: AppColors.baseWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked
                      ? AppColors.accentCyan
                      : AppColors.borderLightGray,
                  width: isUnlocked ? 1.8 : 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x060C3C60),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Badge Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? milestone.accentColor.withValues(alpha: 0.12)
                          : AppColors.softSurfaceGray,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isUnlocked
                            ? milestone.accentColor.withValues(alpha: 0.5)
                            : AppColors.borderLightGray,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isUnlocked ? milestone.icon : Icons.lock_outline_rounded,
                      color: isUnlocked
                          ? milestone.accentColor
                          : AppColors.slateMuted,
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
                                fontWeight: FontWeight.w800,
                                color: isUnlocked
                                    ? AppColors.primaryBlue
                                    : AppColors.slateMuted,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (isUnlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFA7F3D0),
                                  ),
                                ),
                                child: const Text(
                                  'Claimed',
                                  style: TextStyle(
                                    color: Color(0xFF047857),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            else
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slateMuted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          milestone.description,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.slateMuted,
                            height: 1.35,
                          ),
                        ),
                        if (!isUnlocked) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                milestone.accentColor,
                              ),
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
