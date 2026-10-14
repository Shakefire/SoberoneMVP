import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 0 — "What are you working on?"
/// Multi-select substance selection cards with tactile feedback.
class Step0Substances extends StatelessWidget {
  const Step0Substances({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final selected = provider.state.selectedSubstances;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConversationalHeader(
          title: 'What are you working on?',
          subtitle: "Select everything you'd like SoberOne to help you with.",
        ),
        ...OnboardingProvider.substances.map((substance) {
          final isSelected = selected.contains(substance);
          final emoji = OnboardingProvider.substanceEmojis[substance];

          return SelectionCard(
            title: substance,
            emoji: emoji,
            isSelected: isSelected,
            onTap: () => provider.toggleSubstance(substance),
          );
        }),
        const SizedBox(height: 16),
        OnboardingButton(
          label: 'Continue',
          enabled: provider.canProceedStep0,
          onPressed: provider.canProceedStep0 ? () => provider.nextStep() : null,
        ),
      ],
    );
  }
}
