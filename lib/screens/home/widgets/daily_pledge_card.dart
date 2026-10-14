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
        color: hasPledged ? AppColors.cardSelectedBg : AppColors.baseWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasPledged ? AppColors.accentCyan : AppColors.borderLightGray,
          width: hasPledged ? 2.0 : 1.5,
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasPledged
                  ? AppColors.accentCyan
                  : AppColors.accentCyan.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasPledged ? Icons.check_rounded : Icons.handshake_outlined,
              color: hasPledged ? Colors.white : AppColors.accentCyan,
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
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasPledged
                      ? 'You have committed to your promise for today. One day at a time!'
                      : 'Take 5 seconds to promise yourself a clean, sober day today.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: hasPledged ? AppColors.slateText : AppColors.slateMuted,
                    height: 1.35,
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
                  backgroundColor: AppColors.primaryBlue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: Text(
                    hasPledged
                        ? 'Pledge un-checked.'
                        : '🎉 Pledge confirmed! Your commitment today is your greatest strength.',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  hasPledged ? AppColors.accentCyan : AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              hasPledged ? 'Pledged' : 'Pledge',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
