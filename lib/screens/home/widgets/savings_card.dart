import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../models/sobriety_profile.dart';

class SavingsCard extends StatelessWidget {
  final SobrietyProfile profile;

  const SavingsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final money = profile.totalMoneySaved;
    final hours = profile.totalHoursSaved;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLightGray, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060C3C60),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reclaimed Freedom',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Text(
                  'Compounding Daily',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Money Saved
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLightGray),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.savings_rounded,
                              color: Color(0xFF059669), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Money Saved',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slateMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        TimeFormatter.formatCurrency(money),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF047857),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on \$${profile.dailyCost.toStringAsFixed(0)}/day',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.slateMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Time Saved
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLightGray),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.timer_outlined,
                              color: AppColors.accentCyan, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Hours Reclaimed',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slateMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${hours.toStringAsFixed(1)} hrs',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.dailyHoursSaved.toStringAsFixed(1)} hrs/day',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.slateMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
