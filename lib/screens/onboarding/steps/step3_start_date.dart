import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 3 — Start Date Timeline
/// Responsive layout with scroll protection against overflow.
class Step3StartDate extends StatelessWidget {
  const Step3StartDate({super.key});

  Future<void> _pickCustomDate(
      BuildContext context, OnboardingProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryBlue,
            onPrimary: AppColors.baseWhite,
            surface: AppColors.baseWhite,
            onSurface: AppColors.primaryBlue,
            secondary: AppColors.accentCyan,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: AppColors.baseWhite,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      provider.setCustomStartDate(picked);
      provider.setStartWhen(StartWhen.chooseDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final currentWhen = provider.state.startWhen;
    final customDate = provider.state.customStartDate;

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
                      title: 'When would you like to start?',
                      subtitle:
                          'Recovery is on your timeline. Choose when day one begins.',
                    ),
                    ...StartWhen.values.map((when) {
                      final isSelected = currentWhen == when;
                      String subtitle = when.description;
                      if (when == StartWhen.chooseDate && customDate != null) {
                        subtitle =
                            'Selected: ${customDate.day}/${customDate.month}/${customDate.year}';
                      }

                      return SelectionCard(
                        title: when.label,
                        subtitle: subtitle,
                        isSelected: isSelected,
                        onTap: () {
                          if (when == StartWhen.chooseDate) {
                            _pickCustomDate(context, provider);
                          } else {
                            provider.setStartWhen(when);
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    OnboardingButton(
                      label: 'Continue',
                      enabled: currentWhen != null,
                      onPressed: currentWhen != null
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
