import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';
import '../certification/quiz_screen.dart';
import '../rewards/rewards_dashboard.dart';

class TrackerSelectionDrawer extends StatelessWidget {
  const TrackerSelectionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final activeSubstance = sobriety.profile.habitName.isNotEmpty
        ? sobriety.profile.habitName
        : 'Alcohol';
    final elapsedDays = sobriety.profile.elapsedDays;
    final durationText = elapsedDays <= 1 ? '1 day' : '$elapsedDays days';
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      // 1. Drawer Container: occupies roughly 75% to 80% of screen width (78%)
      width: screenWidth * 0.78,
      backgroundColor: AppColors.softSurfaceGray,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. Active Tracker Card
              _buildActiveTrackerCard(
                context: context,
                substanceName: activeSubstance,
                durationText: durationText,
              ),
              const SizedBox(height: 32),

              // 3. Tracker Action Row
              _buildTrackerActionRow(context, sobriety),
              const SizedBox(height: 48), // Generous top margin

              // 4. Informational Text Block
              _buildInformationalTextBlock(),
              const SizedBox(height: 18),

              // Footer Icon
              _buildFooterIcon(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Active Tracker Card: Rounded rectangle, elevated surface
  // ─────────────────────────────────────────────────────────────
  Widget _buildActiveTrackerCard({
    required BuildContext context,
    required String substanceName,
    required String durationText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite, // Elevated surface background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.borderLightGray,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Half: Horizontal flex row with space-between alignment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Active substance name in bold, primary text
                    Expanded(
                      child: Text(
                        substanceName,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),

                    // Right side: Generic substance icon followed immediately by checkmark icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.hexagon_outlined,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.check_rounded,
                          color: AppColors.accentCyan,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider: Faint, 1px horizontal line separating top and bottom halves
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLightGray.withValues(alpha: 0.7),
              ),

              // Bottom Half: Horizontal flex row with space-between alignment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Muted text reading "Sober for:"
                    const Text(
                      'Sober for:',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slateMuted,
                      ),
                    ),

                    // Right side: Bold text displaying the duration
                    Text(
                      durationText,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Tracker Action Row: Horizontally centered row, spaced evenly
  // ─────────────────────────────────────────────────────────────
  Widget _buildTrackerActionRow(BuildContext context, SobrietyProvider sobriety) {
    final isUnlocked = sobriety.isAssessmentPassed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Action 1 (Add New): Circular outlined button + centered muted label
            _buildActionItem(
              icon: Icons.add_rounded,
              label: 'Add New',
              onTap: () => _showAddNewTrackerModal(context, sobriety),
            ),

            // Action 2 (Edit List): Circular outlined button + centered muted label
            _buildActionItem(
              icon: Icons.settings_outlined,
              label: 'Edit List',
              onTap: () => _showEditListModal(context, sobriety),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Locked / Unlocked Menu Item: Reformed Rewards
        _buildReformedRewardsItem(context, sobriety, isUnlocked),
      ],
    );
  }

  Widget _buildReformedRewardsItem(
    BuildContext context,
    SobrietyProvider sobriety,
    bool isUnlocked,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isUnlocked) {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RewardsDashboard()),
            );
          } else {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.baseWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                icon: const Icon(
                  Icons.lock_rounded,
                  color: AppColors.slateMuted,
                  size: 36,
                ),
                title: const Text(
                  'Reformed Rewards Locked',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                  ),
                ),
                content: const Text(
                  'Pass your 90-Day Milestone Clinical Assessment to unlock educational grants, business funding, and toolkits.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.slateText),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Take Assessment'),
                  ),
                ],
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isUnlocked ? AppColors.cardSelectedBg : AppColors.baseWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isUnlocked
                  ? AppColors.accentCyan
                  : AppColors.borderLightGray,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.accentCyan.withValues(alpha: 0.15)
                      : AppColors.softSurfaceGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUnlocked
                      ? Icons.military_tech_rounded
                      : Icons.lock_outline_rounded,
                  color: isUnlocked
                      ? AppColors.accentCyan
                      : AppColors.slateMuted,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reformed Rewards',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isUnlocked
                            ? AppColors.primaryBlue
                            : AppColors.slateText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isUnlocked
                          ? 'Grants & Opportunities Unlocked ★'
                          : 'Locked · Clinical verification required',
                      style: TextStyle(
                        fontSize: 11,
                        color: isUnlocked
                            ? AppColors.accentCyan
                            : AppColors.slateMuted,
                        fontWeight:
                            isUnlocked ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isUnlocked
                    ? Icons.chevron_right_rounded
                    : Icons.lock_rounded,
                size: 18,
                color: isUnlocked
                    ? AppColors.accentCyan
                    : AppColors.slateMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.baseWhite,
              border: Border.all(
                color: AppColors.borderLightGray,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
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
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slateMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Informational Text Block: Centered paragraph of muted text
  // ─────────────────────────────────────────────────────────────
  Widget _buildInformationalTextBlock() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'With Sober Plus, you can add more trackers as you need them.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.slateMuted,
          height: 1.45,
        ),
      ),
    );
  }

  // Footer Icon: small generic logo/icon horizontally centered
  Widget _buildFooterIcon() {
    return Center(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.cardSelectedBg,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.spa_rounded,
          color: AppColors.accentCyan,
          size: 18,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Action Modals: Add New & Edit List
  // ─────────────────────────────────────────────────────────────
  void _showAddNewTrackerModal(BuildContext context, SobrietyProvider sobriety) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Material(
          color: AppColors.baseWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetCtx).size.height * 0.70,
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Tracker',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetCtx),
                    icon: const Icon(Icons.close_rounded, color: AppColors.slateMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a habit or substance to track:',
                style: TextStyle(fontSize: 13, color: AppColors.slateMuted),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: AppConstants.habitCategories.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final item = AppConstants.habitCategories[index];
                    final isCurrent = item == sobriety.profile.habitName;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isCurrent
                              ? AppColors.accentCyan
                              : AppColors.borderLightGray,
                        ),
                      ),
                      tileColor: isCurrent
                          ? AppColors.cardSelectedBg
                          : AppColors.softSurfaceGray,
                      leading: Icon(
                        Icons.hexagon_outlined,
                        color: isCurrent
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue,
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isCurrent
                              ? AppColors.primaryBlue
                              : AppColors.slateText,
                        ),
                      ),
                      trailing: isCurrent
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.accentCyan)
                          : const Icon(Icons.chevron_right_rounded,
                              color: AppColors.slateMuted),
                      onTap: () {
                        sobriety.updateProfile(habitName: item);
                        Navigator.pop(sheetCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryBlue,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text('Switched active tracker to $item'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }

  void _showEditListModal(BuildContext context, SobrietyProvider sobriety) {
    final textController =
        TextEditingController(text: sobriety.profile.habitName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: Material(
            color: AppColors.baseWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Current Tracker',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.slateMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Tracker Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slateMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLightGray),
                  ),
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(
                      color: AppColors.slateText,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter tracker name...',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = textController.text.trim();
                      if (newName.isNotEmpty) {
                        sobriety.updateProfile(habitName: newName);
                      }
                      Navigator.pop(sheetCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primaryBlue,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Text('Tracker name updated to $newName'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
