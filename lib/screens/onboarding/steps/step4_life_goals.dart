import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 4 — Life Improvement Focus
/// Multi-select pills (max 3), tactile feedback, snap to Primary Blue.
class Step4LifeGoals extends StatelessWidget {
  const Step4LifeGoals({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final selectedGoals = provider.state.lifeGoals;
    final isMaxReached = selectedGoals.length >= 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConversationalHeader(
          title: 'What would you like to improve?',
          subtitle: 'Choose up to 3 areas that matter most to you.',
        ),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: LifeGoal.values.map((goal) {
            final isSelected = selectedGoals.contains(goal);
            final isDisabled = !isSelected && isMaxReached;

            return TactilePill(
              label: goal.label,
              emoji: goal.emoji,
              isSelected: isSelected,
              disabled: isDisabled,
              onTap: () => provider.toggleLifeGoal(goal),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (isMaxReached) ...[
          const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.accentCyan),
              SizedBox(width: 6),
              Text(
                'Maximum 3 selected. Tap one to deselect.',
                style: TextStyle(
                  color: AppColors.slateText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 24),
        OnboardingButton(
          label: 'Continue',
          enabled: provider.canProceedStep4,
          onPressed: provider.canProceedStep4 ? () => provider.nextStep() : null,
        ),
      ],
    );
  }
}
