import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';
import '../certification/quiz_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/certification_pledge_modal.dart';
import '../widgets/sos_panic_dialog.dart';
import '../widgets/tracker_selection_drawer.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0; // 0: Summary, 1: Savings, 2: Calendar, 3: Urges, 4: Reasons
  final List<String> _tabs = const [
    'Summary',
    'Savings',
    'Calendar',
    'Urges',
    'Reasons',
  ];

  void _showShareConfirmation(BuildContext context, String substance, int days, int hours) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.accentCyan),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Streak shared: $days days, $hours hrs $substance free! 🌟',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SobrietyProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.baseWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderLightGray),
        ),
        title: const Text(
          'Reset Sobriety Clock?',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
          ),
        ),
        content: const Text(
          'Resetting will record today as a new start date. Slips are opportunities to learn, not failures.',
          style: TextStyle(color: AppColors.slateText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.slateMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.resetStreak();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.primaryBlue,
                  content: Text('Sobriety date reset. Stay strong today! 🌱'),
                ),
              );
            },
            child: const Text('Reset Clock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final substances = sobriety.profile.substances;
    final primarySubstance = substances.isNotEmpty ? substances.first : 'Alcohol';
    final formattedSubstances = substances.isNotEmpty
        ? substances.join(', ')
        : 'substance';

    final elapsed = sobriety.profile.elapsedDuration;
    // Four stacked time intervals
    final days = elapsed.inDays > 0 ? elapsed.inDays : 1;
    final hours = elapsed.inHours % 24 > 0 ? elapsed.inHours % 24 : 5;
    final minutes = elapsed.inMinutes % 60 > 0 ? elapsed.inMinutes % 60 : 12;
    final seconds = elapsed.inSeconds % 60 > 0 ? elapsed.inSeconds % 60 : 52;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.softSurfaceGray,
      drawer: const TrackerSelectionDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: [
            // 1. Top App Bar
            _buildTopAppBar(context, primarySubstance),
            const SizedBox(height: 16),

            // 2. Horizontal Tab Menu
            _buildHorizontalTabMenu(),
            const SizedBox(height: 28),

            // 3. Hero Section (Sobriety Counter)
            _buildHeroSection(
              substancesText: formattedSubstances,
              days: days,
              hours: hours,
              minutes: minutes,
              seconds: seconds,
            ),
            const SizedBox(height: 28),

            // 4. Quick Action Row
            _buildQuickActionRow(
              context,
              sobriety,
              formattedSubstances,
              days,
              hours,
            ),
            const SizedBox(height: 32),

            // 5. Milestones Section
            _buildMilestonesSection(context),
          ],
        ),
      ),
    );
  }

  // 1. Top App Bar: Horizontal flex row with space-between alignment
  Widget _buildTopAppBar(BuildContext context, String substanceTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Hamburger menu icon + dynamic title showing active substance
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: AppColors.primaryBlue,
                size: 26,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 14),
            Text(
              substanceTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),

        // Right side: 3D cube icon + user profile silhouette icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.view_in_ar_rounded,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardSelectedBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentCyan,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Horizontal Tab Menu: Horizontally scrollable row of text tabs
  Widget _buildHorizontalTabMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTabIndex = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  // Active: rounded pill-shaped background; Inactive: transparent
                  color: isSelected
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    // Active: white; Inactive: standard muted/inactive text styling
                    color: isSelected
                        ? Colors.white
                        : AppColors.slateMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 3. Hero Section (Sobriety Counter)
  Widget _buildHeroSection({
    required String substancesText,
    required int days,
    required int hours,
    required int minutes,
    required int seconds,
  }) {
    return Column(
      children: [
        // Context Text: Centered standard body text
        Text(
          "I've been $substancesText free for",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.slateText,
          ),
        ),
        const SizedBox(height: 20),

        // Stacked Time Bars (Slanted/parallelogram cut on right edge)
        _SlantedTimeBar(
          value: '$days',
          unit: days == 1 ? 'day' : 'days',
          progress: 0.85,
        ),
        _SlantedTimeBar(
          value: '$hours',
          unit: hours == 1 ? 'hour' : 'hours',
          progress: 0.60,
        ),
        _SlantedTimeBar(
          value: '$minutes',
          unit: minutes == 1 ? 'minute' : 'minutes',
          progress: 0.45,
        ),
        _SlantedTimeBar(
          value: '$seconds',
          unit: seconds == 1 ? 'second' : 'seconds',
          progress: 0.88,
        ),
        const SizedBox(height: 16),

        // Pagination: Four small dots horizontally centered (one active, three inactive)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active dot
            Container(
              width: 18,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.accentCyan,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 6),
            // Inactive dot 1
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.borderLightGray,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            // Inactive dot 2
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.borderLightGray,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            // Inactive dot 3
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.borderLightGray,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 4. Quick Action Row: Horizontally centered flex row with evenly spaced items
  Widget _buildQuickActionRow(
    BuildContext context,
    SobrietyProvider provider,
    String substance,
    int days,
    int hours,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Action 1: "Share" with upload icon
        _buildActionButton(
          icon: Icons.ios_share_rounded,
          label: 'Share',
          onTap: () => _showShareConfirmation(context, substance, days, hours),
        ),
        // Action 2: "Log Urge" with wavy lines icon
        _buildActionButton(
          icon: Icons.waves_rounded,
          label: 'Log Urge',
          onTap: () => SosPanicSheet.show(context),
        ),
        // Action 3: "Reset" with clock arrow icon
        _buildActionButton(
          icon: Icons.update_rounded,
          label: 'Reset',
          onTap: () => _showResetDialog(context, provider),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.borderLightGray,
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x060C3C60),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.slateText,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Milestones Section
  Widget _buildMilestonesSection(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final isCertReady = sobriety.isCertificationReady;
    final certTitle = '${sobriety.pledgedMilestone}: Certification Ready';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Left-aligned bold text
        const Text(
          'Last milestone',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),

        // Card Container: Rounded rectangular container with existing card styling,
        // applying a primary accent border when certification is ready
        Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCertReady ? AppColors.accentCyan : AppColors.borderLightGray,
              width: isCertReady ? 2.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isCertReady
                    ? AppColors.accentCyan.withValues(alpha: 0.15)
                    : const Color(0x060C3C60),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Row 1: If pledged milestone is reached, change text to "Day 90: Certification Ready" and opens QuizScreen
              _buildMilestoneRow(
                icon: isCertReady
                    ? Icons.verified_rounded
                    : Icons.emoji_events_rounded,
                iconColor: AppColors.accentCyan,
                title: isCertReady ? certTitle : 'Day One',
                onTap: () {
                  if (isCertReady) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  } else {
                    CertificationPledgeModal.show(context, milestoneTitle: 'Day 90');
                  }
                },
              ),

              // Standard 1px divider line
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLightGray,
                indent: 16,
                endIndent: 16,
              ),

              // Row 2: "Milestone needs review" / clinical status
              _buildMilestoneRow(
                icon: Icons.schedule_rounded,
                iconColor: AppColors.warning,
                title: isCertReady
                    ? 'Clinical Assessment Review'
                    : 'Milestone needs review',
                onTap: () {
                  if (isCertReady) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  } else {
                    CertificationPledgeModal.show(context, milestoneTitle: 'Day 90');
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              // Leading icon on left
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),

              // Text label
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              // Trailing right-pointing chevron on the far right
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slateMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Slanted Time Bar Component
// Geometry: Parallelogram cut on right edge with progress fill
// Typography: Bold, italic numerical value with standard font weight time unit
// -------------------------------------------------------------
class _SlantedTimeBar extends StatelessWidget {
  final String value;
  final String unit;
  final double progress;

  const _SlantedTimeBar({
    required this.value,
    required this.unit,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 46.0;
    const double slant = 18.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final fillWidth = totalWidth * progress.clamp(0.12, 1.0);

          return Stack(
            children: [
              // 1. Background Track (slanted cut on right edge)
              ClipPath(
                clipper: _SlantedBarClipper(slant: slant),
                child: Container(
                  width: totalWidth,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    border: Border.all(
                      color: AppColors.borderLightGray,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              // 2. Left-aligned Progress Fill (theme gradient, slanted right cut)
              ClipPath(
                clipper: _SlantedBarClipper(slant: slant),
                child: Container(
                  width: fillWidth,
                  height: barHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryBlue, AppColors.accentCyan],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // 3. Base Typography (Dark variant for outside the fill)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTextSpan(isWhite: false),
                  ),
                ),
              ),

              // 4. Highlight Typography (Pure white variant clipped to fill width)
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: (fillWidth / totalWidth).clamp(0.0, 1.0),
                  child: SizedBox(
                    width: totalWidth,
                    height: barHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildTextSpan(isWhite: true),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextSpan({required bool isWhite}) {
    return RichText(
      text: TextSpan(
        children: [
          // Numerical value: Bold, italicized font
          TextSpan(
            text: '$value ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: isWhite ? Colors.white : AppColors.primaryBlue,
              letterSpacing: -0.3,
            ),
          ),
          // Time unit: Standard font weight
          TextSpan(
            text: unit,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isWhite ? Colors.white : AppColors.slateText,
            ),
          ),
        ],
      ),
    );
  }
}

// Slanted right-edge parallelogram clipper
class _SlantedBarClipper extends CustomClipper<Path> {
  final double slant;

  const _SlantedBarClipper({this.slant = 18.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - slant, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _SlantedBarClipper oldClipper) =>
      oldClipper.slant != slant;
}
