import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 2 — Usage Frequency Routine
/// Dynamic question title reflecting user's selected substances,
/// with visible substance badges and scroll protection against overflow.
class Step2Frequency extends StatelessWidget {
  const Step2Frequency({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final currentFreq = provider.state.frequency;
    final selectedSubstances = provider.state.selectedSubstances;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 48 > 0
                  ? constraints.maxHeight - 48
                  : 0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConversationalHeader(
                      title: provider.frequencyQuestion,
                      subtitle:
                          'This helps us understand your routine and calibrate your milestones.',
                    ),
                    if (selectedSubstances.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedSubstances.map((substance) {
                          final emoji =
                              OnboardingProvider.substanceEmojis[substance];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.cardSelectedBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.accentCyan, width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A0C3C60),
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (emoji != null) ...[
                                  Text(emoji,
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  substance,
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    ...UseFrequency.values.map((freq) {
                      final isSelected = currentFreq == freq;

                      return SelectionCard(
                        title: freq.label,
                        subtitle: freq.description,
                        isSelected: isSelected,
                        onTap: () => provider.setFrequency(freq),
                      );
                    }),
                    const SizedBox(height: 16),
                    OnboardingButton(
                      label: 'Continue',
                      enabled: currentFreq != null,
                      onPressed: currentFreq != null
                          ? () => provider.nextStep()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
