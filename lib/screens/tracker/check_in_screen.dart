import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/check_in.dart';
import '../../providers/check_in_provider.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  MoodLevel _selectedMood = MoodLevel.good;
  double _cravingLevel = 2.0;
  final Set<String> _selectedTriggers = {};
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = context.read<CheckInProvider>().todayCheckIn;
    if (today != null) {
      _selectedMood = today.mood;
      _cravingLevel = today.cravingLevel.toDouble();
      _selectedTriggers.addAll(today.triggers);
      _noteController.text = today.note;
      _gratitudeController.text = today.gratitude;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _gratitudeController.dispose();
    super.dispose();
  }

  void _saveCheckIn() async {
    final provider = context.read<CheckInProvider>();
    await provider.addCheckIn(
      mood: _selectedMood,
      cravingLevel: _cravingLevel.round(),
      triggers: _selectedTriggers.toList(),
      note: _noteController.text.trim(),
      gratitude: _gratitudeController.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Check-in saved! Keep up the incredible work.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          // 1. Mood Section
          Text('How are you feeling today?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Check in honestly with your emotional baseline.', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: MoodLevel.values.map((mood) {
              final isSelected = _selectedMood == mood;
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withAlpha(40) : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderDark,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(mood.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        mood.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primaryLight : AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // 2. Craving Intensity Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Craving Intensity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCravingColor(_cravingLevel.round()).withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_cravingLevel.round()} / 10',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getCravingColor(_cravingLevel.round()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _getCravingDescription(_cravingLevel.round()),
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getCravingColor(_cravingLevel.round()),
              thumbColor: _getCravingColor(_cravingLevel.round()),
              inactiveTrackColor: Colors.white12,
            ),
            child: Slider(
              value: _cravingLevel,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${_cravingLevel.round()}',
              onChanged: (val) => setState(() => _cravingLevel = val),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Triggers Multi-select
          Text('Were you triggered by anything?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Select any triggers that influenced you today.', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.triggerOptions.map((trigger) {
              final isSelected = _selectedTriggers.contains(trigger);
              return FilterChip(
                label: Text(trigger),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTriggers.add(trigger);
                    } else {
                      _selectedTriggers.remove(trigger);
                    }
                  });
                },
                backgroundColor: AppColors.surfaceDark,
                selectedColor: AppColors.secondary.withAlpha(40),
                checkmarkColor: AppColors.secondary,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.secondary : AppColors.borderDark,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // 4. Notes & Reflection
          Text('Journal Reflections', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'What went well today? Any hurdles you navigated?',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMutedDark),
              filled: true,
              fillColor: AppColors.surfaceDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 5. Gratitude
          Text('Gratitude of the Day', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _gratitudeController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Name 1 or 2 things you are grateful for right now...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMutedDark),
              filled: true,
              fillColor: AppColors.surfaceDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveCheckIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Today’s Check-in',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCravingColor(int level) {
    if (level <= 3) return AppColors.success;
    if (level <= 6) return AppColors.warning;
    return AppColors.danger;
  }

  String _getCravingDescription(int level) {
    if (level <= 2) return 'Very mild or non-existent cravings.';
    if (level <= 4) return 'Occasional thought, manageable without stress.';
    if (level <= 7) return 'Noticeable urge, recommended to use breathing / grounding.';
    return 'Severe craving surge — please consider opening the SOS panic toolkit!';
  }
}
