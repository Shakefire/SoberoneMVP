import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Privacy & consent modal sheet styled in the new light-mode palette.
class PrivacyConsentSheet extends StatefulWidget {
  final VoidCallback onAccepted;

  const PrivacyConsentSheet({super.key, required this.onAccepted});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAccepted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => PrivacyConsentSheet(onAccepted: onAccepted),
    );
  }

  @override
  State<PrivacyConsentSheet> createState() => _PrivacyConsentSheetState();
}

class _PrivacyConsentSheetState extends State<PrivacyConsentSheet> {
  bool _agreedToTerms = false;
  bool _consentedToProcessing = false;

  bool get _canContinue => _agreedToTerms && _consentedToProcessing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLightGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tactile shield badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.accentCyan,
                  size: 26,
                ),
              ),
              const SizedBox(height: 18),

              // Title
              const Text(
                'Your privacy comes first',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),

              // Body
              const Text(
                'SoberOne will ask about your substance use, recovery goals and wellbeing to personalize your experience.',
                style: TextStyle(
                  color: AppColors.slateText,
                  fontSize: 14.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your information is private and you can manage or delete your data later.',
                style: TextStyle(
                  color: AppColors.slateText,
                  fontSize: 14.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),

              // Policy links
              Row(
                children: [
                  _LinkText(label: 'Privacy Policy', onTap: () {}),
                  const Text(
                    ' · ',
                    style: TextStyle(color: AppColors.slateText, fontSize: 13),
                  ),
                  _LinkText(label: 'How we use your data', onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),

              const Divider(color: AppColors.borderLightGray, height: 1),
              const SizedBox(height: 18),

              // Checkbox 1
              _TactileCheckboxRow(
                text: 'I agree to the Terms and Privacy Policy',
                value: _agreedToTerms,
                onChanged: (v) => setState(() => _agreedToTerms = v),
              ),
              const SizedBox(height: 14),

              // Checkbox 2
              _TactileCheckboxRow(
                text:
                    'I consent to the processing of my recovery-related information as described',
                value: _consentedToProcessing,
                onChanged: (v) => setState(() => _consentedToProcessing = v),
              ),
              const SizedBox(height: 24),

              // Continue CTA
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _canContinue ? 1.0 : 0.35,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _canContinue
                        ? () {
                            Navigator.of(context).pop();
                            widget.onAccepted();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      disabledBackgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.baseWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: AppColors.baseWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkText({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accentCyan,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.accentCyan,
        ),
      ),
    );
  }
}

class _TactileCheckboxRow extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TactileCheckboxRow({
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: value ? AppColors.accentCyan : AppColors.baseWhite,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.accentCyan : AppColors.borderLightGray,
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.slateText,
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
