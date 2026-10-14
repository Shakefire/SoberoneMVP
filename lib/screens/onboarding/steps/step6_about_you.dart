import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_widgets.dart';

/// Step 6 — Demographics & Regional Setup
/// Age range pills, Country dropdown, State/region input with animated floating label,
/// privacy assurance card, and final launch CTA button.
class Step6AboutYou extends StatefulWidget {
  final VoidCallback onComplete;

  const Step6AboutYou({super.key, required this.onComplete});

  @override
  State<Step6AboutYou> createState() => _Step6AboutYouState();
}

class _Step6AboutYouState extends State<Step6AboutYou> {
  late final TextEditingController _regionController;

  static const List<String> _countries = [
    'Nigeria',
    'United Kingdom',
    'United States',
    'Ghana',
    'South Africa',
    'Kenya',
    'Canada',
    'Australia',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<OnboardingProvider>();
    _regionController = TextEditingController(text: provider.state.region);
  }

  @override
  void dispose() {
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final state = provider.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConversationalHeader(
          title: 'A little about you',
          subtitle:
              'We use this to tailor resources and emergency support to your region.',
        ),

        // Age range section
        const Text(
          'Age range',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AgeRange.values.map((age) {
            return TactilePill(
              label: age.label,
              isSelected: state.ageRange == age,
              onTap: () => provider.setAgeRange(age),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Country selection
        const Text(
          'Country',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TactileDropdown<String>(
          label: 'Country',
          value: _countries.contains(state.country)
              ? state.country
              : _countries.first,
          items: _countries.map((c) {
            return DropdownMenuItem(
              value: c,
              child: Text(c),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              provider.setCountry(val);
            }
          },
        ),

        const SizedBox(height: 22),

        // State / Region input
        TactileTextInput(
          label: 'State / Region (Optional)',
          hint: 'e.g. Lagos, Rivers State, Abuja',
          controller: _regionController,
          onChanged: (val) => provider.setRegion(val),
        ),

        const SizedBox(height: 26),

        // Privacy reassurance card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLightGray),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: AppColors.accentCyan,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your data stays on your device.',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SoberOne does not sell your recovery journey data. You can export or erase everything in settings at any time.',
                      style: TextStyle(
                        color: AppColors.slateText,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        OnboardingButton(
          label: 'Start SoberOne',
          enabled: provider.canProceedStep6,
          onPressed: provider.canProceedStep6 ? widget.onComplete : null,
        ),
      ],
    );
  }
}
