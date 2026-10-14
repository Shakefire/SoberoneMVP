import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 5 — Support Style & Privacy Preference
/// Responsive layout with scroll protection against overflow.
class Step5SupportStyle extends StatelessWidget {
  const Step5SupportStyle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final currentStyle = provider.state.supportStyle;

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
                      title: 'How would you like to do this?',
                      subtitle:
                          'Choose the level of privacy and support that feels right.',
                    ),
                    ...SupportStyle.values.map((style) {
                      final isSelected = currentStyle == style;

                      return SelectionCard(
                        title: style.label,
                        subtitle: style.description,
                        isSelected: isSelected,
                        onTap: () => provider.setSupportStyle(style),
                      );
                    }),
                    const SizedBox(height: 16),
                    OnboardingButton(
                      label: 'Continue',
                      enabled: currentStyle != null,
                      onPressed: currentStyle != null
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
