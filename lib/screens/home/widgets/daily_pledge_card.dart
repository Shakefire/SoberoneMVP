import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/sobriety_provider.dart';

class DailyPledgeCard extends StatelessWidget {
  const DailyPledgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final hasPledged = sobriety.profile.hasPledgedToday;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: hasPledged
            ? const LinearGradient(
                colors: [Color(0xFF0F3A2E), Color(0xFF132B25)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF1C2541), Color(0xFF161E36)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasPledged ? AppColors.primary.withAlpha(120) : AppColors.borderDark,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasPledged
                  ? AppColors.primary
                  : AppColors.surfaceDarkLight.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasPledged ? Icons.check_rounded : Icons.handshake_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPledged ? 'Pledge Honored Today' : 'Daily Sobriety Pledge',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasPledged
                      ? 'You have committed to your promise for today. One day at a time!'
                      : 'Take 5 seconds to promise yourself a clean, sober day today.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              sobriety.togglePledgeToday();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: hasPledged ? AppColors.surfaceDark : AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: Text(
                    hasPledged
                        ? 'Pledge un-checked.'
                        : '🎉 Pledge confirmed! Your commitment today is your greatest strength.',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: hasPledged ? AppColors.primary : AppColors.surfaceDarkLight,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              hasPledged ? 'Pledged' : 'Pledge',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: hasPledged ? Colors.white : AppColors.textPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
