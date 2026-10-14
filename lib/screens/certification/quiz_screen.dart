import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';
import '../widgets/booking_modal.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isAfterPhotoSnapped = false;
  final Map<int, String> _selectedAnswers = {
    0: '4-7-8 Breathing',
    1: 'Social Bars',
    2: 'Cognitive Reframing',
    3: 'Sponsor Contact',
    4: 'Sparkling Water',
    5: 'One Day At A Time',
    6: 'Restful Sleep',
    7: 'Clear "No" Responses',
    8: 'Mental Freedom',
    9: 'Fully Ready',
  };

  final List<Map<String, dynamic>> _questions = const [
    {
      'title': '1. Primary Craving Defusal Strategy',
      'options': ['4-7-8 Breathing', 'Sensory Grounding', 'Urge Surfing', 'Peer Venting'],
    },
    {
      'title': '2. Identified High-Risk Trigger Environment',
      'options': ['Social Bars', 'Work Stress', 'Isolation', 'Physical Fatigue'],
    },
    {
      'title': '3. Emotional Regulation Approach',
      'options': ['Cognitive Reframing', 'Daily Gratitude', 'Mindfulness', 'Physical Exercise'],
    },
    {
      'title': '4. Emergency Support Network Protocol',
      'options': ['Sponsor Contact', 'Peer Group Chat', 'Support Consultant', 'Journaling'],
    },
    {
      'title': '5. Behavioral Habit Substitution Routine',
      'options': ['Sparkling Water', 'Evening Walks', 'Reading', 'New Creative Hobbies'],
    },
    {
      'title': '6. Relapse Prevention Philosophy',
      'options': ['One Day At A Time', 'Strict Accountability', 'Self-Compassion', 'Zero Complacency'],
    },
    {
      'title': '7. Physical Recovery Markers Observed',
      'options': ['Restful Sleep', 'Clearer Focus', 'Stable Appetite', 'Lower Blood Pressure'],
    },
    {
      'title': '8. Social Boundary Setting Technique',
      'options': ['Clear "No" Responses', 'Early Departures', 'Non-Drinking Allies', 'Dry Venues'],
    },
    {
      'title': '9. Long-Term Sobriety Anchor',
      'options': ['Family Presence', 'Career Excellence', 'Mental Freedom', 'Financial Security'],
    },
    {
      'title': '10. Readiness for Clinical Verification',
      'options': ['Fully Ready', 'Confident & Clear', 'Eager for Assessment', 'Committed to Grant Growth'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sobriety = context.watch<SobrietyProvider>();

    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  // Phase Badge & Header
                  _buildHeaderBanner(),
                  const SizedBox(height: 18),

                  // Split-View Before & After Photo Card
                  _buildCelebratorySplitView(sobriety),
                  const SizedBox(height: 24),

                  // 10-Question Quiz Header
                  const Text(
                    'Milestone Mastery Quiz',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select the strategy that best reflects your recovery habits.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.slateMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 10 dynamic questions with Flexbox pill selections
                  ..._questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final q = entry.value;
                    return _buildQuestionCard(index, q['title'] as String, q['options'] as List<String>);
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Fixed Bottom Submit Button
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.slateText, size: 24),
            splashRadius: 22,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Certification Assessment',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slateText,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140C3C60),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: AppColors.accentCyan,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day 90: Milestone Verified',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Complete your quiz & schedule Clinical Review to unlock Reformed Rewards.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Celebratory Split-view Before & After Photo Card
  Widget _buildCelebratorySplitView(SobrietyProvider sobriety) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLightGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060C3C60),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Biometric Transformation',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardSelectedBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  'Day 0 vs Day 90',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Split row
          Row(
            children: [
              // Before photo block
              Expanded(
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLightGray),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: 0.08),
                        ),
                        child: const Icon(
                          Icons.face_rounded,
                          color: AppColors.primaryBlue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Day 0 Before',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slateText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Pledge Verified 🔒',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.slateMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // After photo block (interactive camera capture)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAfterPhotoSnapped = !_isAfterPhotoSnapped;
                    });
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: _isAfterPhotoSnapped
                          ? AppColors.cardSelectedBg
                          : AppColors.softSurfaceGray,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _isAfterPhotoSnapped
                            ? AppColors.accentCyan
                            : AppColors.borderLightGray,
                        width: _isAfterPhotoSnapped ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isAfterPhotoSnapped
                                ? AppColors.accentCyan.withValues(alpha: 0.15)
                                : AppColors.accentCyan.withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            _isAfterPhotoSnapped
                                ? Icons.check_circle_rounded
                                : Icons.camera_alt_rounded,
                            color: AppColors.accentCyan,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isAfterPhotoSnapped ? 'Day 90 After ✓' : 'Snap Day 90 Photo',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: _isAfterPhotoSnapped
                                ? AppColors.primaryBlue
                                : AppColors.accentCyan,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isAfterPhotoSnapped ? 'Tap to retake' : 'Tap to capture',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.slateMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Question Card reusing Flexbox pill selection logic from Daily Check-In
  Widget _buildQuestionCard(int index, String title, List<String> options) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected = _selectedAnswers[index] == opt;
              return GestureDetector(
                onTap: () => setState(() => _selectedAnswers[index] = opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cardSelectedBg
                        : AppColors.softSurfaceGray,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentCyan
                          : AppColors.borderLightGray,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.accentCyan,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        opt,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.slateText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.baseWhite,
        border: Border(top: BorderSide(color: AppColors.borderLightGray)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // Save quiz completion in provider
            context.read<SobrietyProvider>().completeQuiz(
              afterPhotoPath: 'after_day90_selfie.jpg',
            );

            // Route user directly to Phase C: Clinical Assessment Booking Modal
            BookingModal.show(
              context,
              sessionType: 'certification',
              onBookingConfirmed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Return to Dashboard
                }
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Submit & Unlock Assessment',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}
