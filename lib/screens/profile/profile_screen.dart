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
              backgroundColor: AppColors.surfaceDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Edit Tracker Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target Habit / Substance', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: AppConstants.habitCategories.contains(selectedHabit) ? selectedHabit : AppConstants.habitCategories.first,
                      items: AppConstants.habitCategories.map((h) {
                        return DropdownMenuItem(value: h, child: Text(h));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedHabit = val);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Quit Date & Time', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
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
                            initialTime: TimeOfDay.fromDateTime(selectedDate),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderDark),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(TimeFormatter.formatDateTime(selectedDate)),
                            const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Estimated Daily Cost Saved (\$)', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        filled: true,
                        fillColor: AppColors.backgroundDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Estimated Daily Hours Reclaimed', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: hoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        suffixText: 'hrs / day',
                        filled: true,
                        fillColor: AppColors.backgroundDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('My "Why" (Core Motivation)', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g. For my children, my health, and clarity',
                        filled: true,
                        fillColor: AppColors.backgroundDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final cost = double.tryParse(costController.text.trim()) ?? profile.dailyCost;
                    final hours = double.tryParse(hoursController.text.trim()) ?? profile.dailyHoursSaved;
                    sobriety.updateProfile(
                      habitName: selectedHabit,
                      quitDate: selectedDate,
                      dailyCost: cost,
                      dailyHoursSaved: hours,
                      reasonWhy: reasonController.text.trim(),
                    );
                    Navigator.pop(ctx);
                  },
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
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(Icons.restart_alt_rounded, color: AppColors.warning, size: 28),
              SizedBox(width: 10),
              Text('Reset Streak?'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remember: A slip is never a failure, it is information.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Every day you were sober cannot be taken away from you. Resetting simply marks the starting point for your next chapter.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Keep Current Streak'),
            ),
            ElevatedButton(
              onPressed: () {
                sobriety.resetStreak();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Streak reset. We stand with you today — Day 1 begins now.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
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
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderDark),
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
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sober Champion',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quitting ${profile.habitName}',
                            style: const TextStyle(fontSize: 13, color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondaryDark),
                      onPressed: () => _showEditProfileDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white10),
                const SizedBox(height: 12),

                // Motivation quote box
                const Text(
                  'MY CORE "WHY"',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.textMutedDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"${profile.reasonWhy}"',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Settings list
          Material(
            color: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: AppColors.borderDark),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: AppColors.primary),
                  title: const Text('Tracker & Cost Preferences'),
                  subtitle: Text('\$${profile.dailyCost.toStringAsFixed(0)}/day • ${profile.dailyHoursSaved.toStringAsFixed(1)} hrs/day'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showEditProfileDialog(context),
                ),
                const Divider(color: Colors.white10, height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined, color: AppColors.secondary),
                  title: const Text('Daily Morning Pledge Reminder'),
                  subtitle: const Text('Scheduled for 8:00 AM daily'),
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeThumbColor: AppColors.primary,
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline_rounded, color: AppColors.accent),
                  title: const Text('Privacy & Confidentiality'),
                  subtitle: const Text('Data is stored offline on this device'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.surfaceDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('Privacy Promise'),
                        content: const Text(
                          'SoberOne stores your journal logs, check-ins, and sobriety dates securely on your local device. We respect your healing journey completely.',
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Understood')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reset streak button
          Material(
            color: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.danger.withAlpha(50)),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.restart_alt_rounded, color: AppColors.danger),
              title: const Text(
                'Reset Sobriety Streak',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Had a slip? Reset guilt-free and start fresh.'),
              onTap: () => _showResetConfirmation(context),
            ),
          ),
          const SizedBox(height: 32),

          // App info
          const Center(
            child: Text(
              'SoberOne v1.0.0 • Mobile Frontend\nCrafted with compassion for recovery',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMutedDark, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
