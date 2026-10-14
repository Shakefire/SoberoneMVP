import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/time_formatter.dart';
import '../../providers/sobriety_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final sobriety = context.read<SobrietyProvider>();
    final profile = sobriety.profile;

    String selectedHabit = profile.habitName;
    DateTime selectedDate = profile.quitDate;
    final costController = TextEditingController(text: profile.dailyCost.toStringAsFixed(0));
    final hoursController = TextEditingController(text: profile.dailyHoursSaved.toStringAsFixed(1));
    final reasonController = TextEditingController(text: profile.reasonWhy);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.baseWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppColors.borderLightGray),
              ),
              title: const Text(
                'Edit Tracker Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Habit / Substance',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: AppConstants.habitCategories
                              .contains(selectedHabit)
                          ? selectedHabit
                          : AppConstants.habitCategories.first,
                      items: AppConstants.habitCategories.map((h) {
                        return DropdownMenuItem(value: h, child: Text(h));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedHabit = val);
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.softSurfaceGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Quit Date & Time',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null && ctx.mounted) {
                          final pickedTime = await showTimePicker(
                            context: ctx,
                            initialTime:
                                TimeOfDay.fromDateTime(selectedDate),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.softSurfaceGray,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.borderLightGray),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TimeFormatter.formatDateTime(selectedDate),
                              style: const TextStyle(
                                  color: AppColors.slateText,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(Icons.calendar_today_rounded,
                                size: 18, color: AppColors.accentCyan),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Estimated Daily Cost Saved (\$)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      style: const TextStyle(
                          color: AppColors.slateText,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        filled: true,
                        fillColor: AppColors.softSurfaceGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Estimated Daily Hours Reclaimed',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: hoursController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      style: const TextStyle(
                          color: AppColors.slateText,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        suffixText: 'hrs / day',
                        filled: true,
                        fillColor: AppColors.softSurfaceGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'My "Why" (Core Motivation)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      style: const TextStyle(color: AppColors.slateText),
                      decoration: InputDecoration(
                        hintText:
                            'e.g. For my children, my health, and clarity',
                        hintStyle:
                            const TextStyle(color: AppColors.slateMuted),
                        filled: true,
                        fillColor: AppColors.softSurfaceGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.borderLightGray),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.slateMuted),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final cost =
                        double.tryParse(costController.text.trim()) ??
                            profile.dailyCost;
                    final hours =
                        double.tryParse(hoursController.text.trim()) ??
                            profile.dailyHoursSaved;
                    sobriety.updateProfile(
                      habitName: selectedHabit,
                      quitDate: selectedDate,
                      dailyCost: cost,
                      dailyHoursSaved: hours,
                      reasonWhy: reasonController.text.trim(),
                    );
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.baseWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context) {
    final sobriety = context.read<SobrietyProvider>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.baseWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.borderLightGray),
          ),
          title: const Row(
            children: [
              Icon(Icons.restart_alt_rounded,
                  color: AppColors.danger, size: 28),
              SizedBox(width: 10),
              Text(
                'Reset Streak?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remember: A slip is never a failure, it is information.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Every day you were sober cannot be taken away from you. Resetting simply marks the starting point for your next chapter.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.slateText,
                  height: 1.45,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.slateMuted),
              child: const Text('Keep Current Streak'),
            ),
            ElevatedButton(
              onPressed: () {
                sobriety.resetStreak();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.primaryBlue,
                    content: Text(
                        'Streak reset. We stand with you today — Day 1 begins now.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Reset to Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();
    final profile = sobriety.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // Profile Hero Card
          // Profile Hero Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(24),
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
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: AppColors.primaryBlue, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sober Champion',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quitting ${profile.habitName}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.slateMuted),
                      onPressed: () => _showEditProfileDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.borderLightGray),
                const SizedBox(height: 12),

                // Motivation quote box
                const Text(
                  'MY CORE "WHY"',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.slateMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"${profile.reasonWhy}"',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Settings list
          Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x060C3C60),
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Material(
              color: AppColors.baseWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(
                    color: AppColors.borderLightGray, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune_rounded,
                        color: AppColors.primaryBlue),
                    title: const Text(
                      'Tracker & Cost Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      '\$${profile.dailyCost.toStringAsFixed(0)}/day • ${profile.dailyHoursSaved.toStringAsFixed(1)} hrs/day',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.slateMuted,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.slateMuted),
                    onTap: () => _showEditProfileDialog(context),
                  ),
                  const Divider(color: AppColors.borderLightGray, height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined,
                        color: AppColors.accentCyan),
                    title: const Text(
                      'Daily Morning Pledge Reminder',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text(
                      'Scheduled for 8:00 AM daily',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.slateMuted,
                      ),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (val) {},
                      activeThumbColor: AppColors.primaryBlue,
                      activeTrackColor:
                          AppColors.accentCyan.withValues(alpha: 0.25),
                    ),
                  ),
                  const Divider(color: AppColors.borderLightGray, height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.accentCyan),
                    title: const Text(
                      'Privacy & Confidentiality',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text(
                      'Data is stored offline on this device',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.slateMuted,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.slateMuted),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.baseWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: AppColors.borderLightGray),
                          ),
                          title: const Text(
                            'Privacy Promise',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          content: const Text(
                            'SoberOne stores your journal logs, check-ins, and sobriety dates securely on your local device. We respect your healing journey completely.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.slateText,
                              height: 1.45,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryBlue),
                              child: const Text('Understood'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Reset streak button
          Material(
            color: const Color(0xFFFFF1F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFFDA4AF), width: 1.2),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.restart_alt_rounded,
                  color: Color(0xFFE11D48)),
              title: const Text(
                'Reset Sobriety Streak',
                style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Had a slip? Reset guilt-free and start fresh.',
                style: TextStyle(
                  color: AppColors.slateMuted,
                  fontSize: 12.5,
                ),
              ),
              onTap: () => _showResetConfirmation(context),
            ),
          ),
          const SizedBox(height: 32),

          // App info
          const Center(
            child: Text(
              'SoberOne v1.0.0 • Mobile Frontend\nCrafted with compassion for recovery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.slateMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
