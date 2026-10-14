import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../screens/main_navigation_screen.dart';
import 'widgets/onboarding_widgets.dart';
import 'widgets/privacy_consent_sheet.dart';
import 'steps/step0_substances.dart';
import 'steps/step1_goal.dart';
import 'steps/step2_frequency.dart';
import 'steps/step3_start_date.dart';
import 'steps/step4_life_goals.dart';
import 'steps/step5_support_style.dart';
import 'steps/step6_about_you.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _onGetStarted(BuildContext context) {
    PrivacyConsentSheet.show(
      context,
      onAccepted: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context2, a1, a2) => ChangeNotifierProvider(
              create: (_) => OnboardingProvider(),
              child: const _OnboardingFlow(),
            ),
            transitionsBuilder: (context2, animation, a2, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 220),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: AppColors.softSurfaceGray,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40 > 0
                        ? constraints.maxHeight - 40
                        : 0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),

                          // App Icon Branding with soft shadow
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  offset: const Offset(0, 8),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Image.asset(
                                'assets/images/icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Main Welcome Title
                          const Text(
                            'First of all, congrats!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Subtitle with 145% line height
                          const Text(
                            "You've just taken a big step on the path to\nsobriety and lifelong recovery.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.slateText,
                              fontSize: 15,
                              height: 1.45,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Get Started Primary CTA
                          OnboardingButton(
                            label: 'Get Started',
                            onPressed: () => _onGetStarted(context),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Returning user with data to restore?',
                            style: TextStyle(
                              color: AppColors.slateText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // High-Contrast Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () => _showSignInSheet(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.baseWhite,
                                foregroundColor: AppColors.primaryBlue,
                                side: const BorderSide(
                                  color: AppColors.primaryBlue,
                                  width: 2.0,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login_rounded,
                                    size: 20,
                                    color: AppColors.primaryBlue,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSignInSheet(BuildContext context) {
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Theme(
          data: AppTheme.lightTheme,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in to restore your sobriety milestones and personal journal.',
                    style: TextStyle(
                      color: AppColors.slateText,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TactileTextInput(
                    label: 'Email Address',
                    hint: 'you@example.com',
                    controller: emailController,
                  ),
                  const SizedBox(height: 22),
                  OnboardingButton(
                    label: 'Restore & Continue',
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (c2, a1, a2) =>
                              const MainNavigationScreen(),
                          transitionsBuilder: (c2, animation, a2, child) =>
                              FadeTransition(opacity: animation, child: child),
                          transitionDuration: const Duration(milliseconds: 350),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The 7-step onboarding flow with Segmented Progress Bar and Shared X-Axis Transitions.
class _OnboardingFlow extends StatelessWidget {
  const _OnboardingFlow();

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (c2, a1, a2) => const MainNavigationScreen(),
        transitionsBuilder: (c2, animation, a2, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final step = provider.currentStep;
    final isForward = provider.isMovingForward;

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: AppColors.softSurfaceGray,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar with Back Button and Segmented Progress Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  if (step > 0)
                    OnboardingBackButton(
                      onTap: () => provider.previousStep(),
                    )
                  else
                    const SizedBox(width: 40, height: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SegmentedProgressBar(
                      totalSegments: OnboardingProvider.totalSteps,
                      currentSegment: step,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Symmetric empty spacer to balance the back button
                  const SizedBox(width: 40, height: 40),
                ],
              ),
            ),

            // Question Content with Shared X-Axis Transition
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      // Shared X-Axis transition:
                      // Forward: new enters from right (+0.08), old exits to left (-0.08)
                      // Backward: new enters from left (-0.08), old exits to right (+0.08)
                      final offsetBegin = isForward
                          ? const Offset(0.08, 0.0)
                          : const Offset(-0.08, 0.0);

                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );

                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: offsetBegin,
                          end: Offset.zero,
                        ).animate(curvedAnimation),
                        child: FadeTransition(
                          opacity: curvedAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<int>(step),
                      child: _buildStepContent(
                        context,
                        step,
                        () => _navigateToHome(context),
                      ),
                    ),
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

  Widget _buildStepContent(
      BuildContext context, int step, VoidCallback onComplete) {
    switch (step) {
      case 0:
        return const SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Step0Substances(),
        );
      case 1:
        return const Step1Goal();
      case 2:
        return const Step2Frequency();
      case 3:
        return const Step3StartDate();
      case 4:
        return const SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Step4LifeGoals(),
        );
      case 5:
        return const Step5SupportStyle();
      case 6:
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Step6AboutYou(onComplete: onComplete),
        );
      default:
        return const Step0Substances();
    }
  }
}
