import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 1 — "What's your goal?"
/// Centered responsive layout with scroll protection against overflow.
class Step1Goal extends StatelessWidget {
  const Step1Goal({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final currentGoal = provider.state.goal;

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
                    const ConversationalHeader(
                      title: "What's your goal?",
                      subtitle: 'Choose the path that fits you best right now.',
                    ),
                    ...SoberGoal.values.map((goal) {
                      final isSelected = currentGoal == goal;

                      return SelectionCard(
                        title: goal.label,
                        subtitle: goal.description,
                        isSelected: isSelected,
                        onTap: () => provider.setGoal(goal),
                      );
                    }),
                    const SizedBox(height: 16),
                    OnboardingButton(
                      label: 'Continue',
                      enabled: currentGoal != null,
                      onPressed: currentGoal != null
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
