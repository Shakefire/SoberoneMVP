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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.spa_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SoberOne',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          // SOS Craving Button in Top Bar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => SosPanicSheet.show(context),
              icon: const Icon(Icons.shield_outlined, size: 16),
              label: const Text('SOS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: AppColors.danger.withAlpha(100),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            // Daily Check-In Prompt Banner (if not yet completed)
            if (!hasCheckedInToday) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note_rounded, color: AppColors.secondary, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Check-in Pending',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            'Log your mood and cravings for today.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CheckInScreen()),
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
      ),
    );
  }
}
