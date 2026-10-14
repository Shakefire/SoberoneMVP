import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';
import '../../providers/check_in_provider.dart';
import '../widgets/sos_panic_dialog.dart';
import '../tracker/check_in_screen.dart';
import 'widgets/counter_card.dart';
import 'widgets/next_milestone_card.dart';
import 'widgets/savings_card.dart';
import 'widgets/daily_pledge_card.dart';
import 'widgets/quote_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final checkIn = context.watch<CheckInProvider>();
    final profile = sobriety.profile;
    final hasCheckedInToday = checkIn.todayCheckIn != null;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // Top Title & SOS Quick Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today’s Focus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'One moment, one choice at a time.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.slateMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => SosPanicSheet.show(context),
                icon: const Icon(Icons.shield_rounded, size: 16),
                label: const Text('SOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Daily Check-In Prompt Banner (if not yet completed)
          if (!hasCheckedInToday) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardSelectedBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.5)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x060C3C60),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note_rounded,
                      color: AppColors.accentCyan, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Check-in Pending',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        Text(
                          'Log your mood and cravings for today.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.slateText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckInScreen()),
                      );
                    },
                    child: const Text('Check In'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Main Live Sobriety Counter
          CounterCard(profile: profile),
          const SizedBox(height: 16),

          // Daily Pledge Card
          const DailyPledgeCard(),
          const SizedBox(height: 16),

          // Next Milestone Card
          NextMilestoneCard(
            milestone: sobriety.nextMilestone,
            elapsed: profile.elapsedDuration,
          ),
          const SizedBox(height: 16),

          // Reclaimed Freedom (Money & Time Saved)
          SavingsCard(profile: profile),
          const SizedBox(height: 16),

          // Daily Reflection Quote
          const DailyQuoteCard(),
        ],
      ),
    );
  }
}
