import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/check_in.dart';
import '../../providers/check_in_provider.dart';

// Custom Slider Track Shape with solid active track and segmented / dotted inactive track
class SegmentedSliderTrackShape extends RoundedRectSliderTrackShape {
  const SegmentedSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final double trackHeight = sliderTheme.trackHeight!;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
    );

    // Active Track Paint (Accent Cyan)
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? AppColors.accentCyan
      ..style = PaintingStyle.fill;

    // Inactive Track Paint (Dotted / Segmented)
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    // Draw solid active track
    final Rect activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top - (additionalActiveTrackHeight / 2),
      thumbCenter.dx,
      trackRect.bottom + (additionalActiveTrackHeight / 2),
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, Radius.circular(trackHeight / 2)),
      activePaint,
    );

    // Draw segmented / dotted inactive track
    final double inactiveStart = thumbCenter.dx + 4.0;
    final double inactiveEnd = trackRect.right;
    if (inactiveEnd > inactiveStart) {
      const double segmentWidth = 6.0;
      const double gap = 4.0;
      double currentX = inactiveStart;
      while (currentX < inactiveEnd) {
        final double endX = (currentX + segmentWidth).clamp(currentX, inactiveEnd);
        final Rect segmentRect = Rect.fromLTRB(
          currentX,
          trackRect.top,
          endX,
          trackRect.bottom,
        );
        context.canvas.drawRRect(
          RRect.fromRectAndRadius(segmentRect, Radius.circular(trackHeight / 2)),
          inactivePaint,
        );
        currentX += segmentWidth + gap;
      }
    }
  }
}

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  MoodLevel _selectedMood = MoodLevel.good;
  double _cravingLevel = 2.0;
  final Set<String> _selectedTriggers = {'Social Gathering', 'Fatigue / Exhaustion'};
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();
  bool _isChallengeCompleted = false;
  double _challengeScale = 1.0;

  @override
  void initState() {
    super.initState();
    final today = context.read<CheckInProvider>().todayCheckIn;
    if (today != null) {
      _selectedMood = today.mood;
      _cravingLevel = today.cravingLevel.toDouble();
      _selectedTriggers.clear();
      _selectedTriggers.addAll(today.triggers);
      _noteController.text = today.note;
      _gratitudeController.text = today.gratitude;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _gratitudeController.dispose();
    super.dispose();
  }

  void _saveCheckIn() async {
    final provider = context.read<CheckInProvider>();
    await provider.addCheckIn(
      mood: _selectedMood,
      cravingLevel: _cravingLevel.round(),
      triggers: _selectedTriggers.toList(),
      note: _noteController.text.trim(),
      gratitude: _gratitudeController.text.trim(),
    );

    if (!mounted) return;
    if (_isChallengeCompleted) {
      _showBadgeEarnedModal(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.accentCyan),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Check-in saved! Keep up the incredible work.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _showBadgeEarnedModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (modalCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderLightGray, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stylized Vector Badge
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Badge Earned!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Hydration Champion',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You crushed today\'s challenge: Drink 2L of water! Consistency builds unshakeable resilience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.slateMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(modalCtx);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
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
                    'Claim & Return to Dashboard',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softSurfaceGray, // Soft Surface Gray (#F8FAFC)
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar: Horizontal flex row with back arrow and bold centered title
            _buildTopAppBar(context),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  // 2. Mood Section ("How are you feeling today?")
                  _buildMoodSection(),
                  const SizedBox(height: 26),

                  // 3. Craving Intensity Section
                  _buildCravingSection(),
                  const SizedBox(height: 26),

                  // 4. Triggers Section ("Were you triggered by anything?")
                  _buildTriggersSection(),
                  const SizedBox(height: 26),

                  // 5. Journal Reflections (Text Area)
                  _buildJournalSection(),
                  const SizedBox(height: 20),

                  // 5. Gratitude of the Day (Text Area)
                  _buildGratitudeSection(),
                  const SizedBox(height: 24),

                  // Today's Challenge Section
                  _buildChallengeSection(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // 6. Fixed Action Button (Bottom Anchor)
            _buildFixedBottomButton(context),
          ],
        ),
      ),
    );
  }

  // 1. Top App Bar: Horizontal flex row with back arrow and bold dark slate title
  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.slateText,
              size: 24,
            ),
            splashRadius: 22,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Daily Check-In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slateText, // Bold, dark slate text
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 44), // Balances the back arrow button to keep title centered
        ],
      ),
    );
  }

  // 2. Mood Section ("How are you feeling today?")
  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.slateText,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Check in honestly with your emotional baseline.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slateMuted,
          ),
        ),
        const SizedBox(height: 14),
        // Horizontally scrollable row of rounded, square cards (not full width)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: MoodLevel.values.map((mood) {
              final isSelected = _selectedMood == mood;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 76,
                    height: 82,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cardSelectedBg : AppColors.baseWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.accentCyan : AppColors.borderLightGray,
                        width: isSelected ? 2.0 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.accentCyan.withValues(alpha: 0.15)
                              : const Color(0x060C3C60),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood.emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mood.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.accentCyan : AppColors.slateMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 3. Craving Intensity Section
  Widget _buildCravingSection() {
    final int level = _cravingLevel.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Horizontal flex row with "Craving Intensity" on left and rounded badge on right
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Craving Intensity',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.slateText,
                letterSpacing: -0.3,
              ),
            ),
            // Small, rounded badge reading "2 / 10" with very light green background and darker green text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5), // Very light green background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Text(
                '$level / 10',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF047857), // Darker green text
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Subtitle: Left-aligned muted text
        Text(
          _getCravingDescription(level),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.slateMuted,
          ),
        ),
        const SizedBox(height: 12),
        // Slider: Horizontal slider with Accent Cyan thumb and active track, and dotted/segmented inactive track
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            trackShape: const SegmentedSliderTrackShape(),
            activeTrackColor: AppColors.accentCyan,
            inactiveTrackColor: AppColors.borderLightGray,
            thumbColor: AppColors.accentCyan,
            overlayColor: AppColors.accentCyan.withValues(alpha: 0.16),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 2,
            ),
          ),
          child: Slider(
            value: _cravingLevel,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (val) => setState(() => _cravingLevel = val),
          ),
        ),
      ],
    );
  }

  // 4. Triggers Section ("Were you triggered by anything?")
  Widget _buildTriggersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Were you triggered by anything?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.slateText,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Select any triggers that influenced you today.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slateMuted,
          ),
        ),
        const SizedBox(height: 12),
        // Redesigned from rigid grid to wrapping Flexbox
        Wrap(
          spacing: 8,
          runSpacing: 9,
          children: AppConstants.triggerOptions.map((trigger) {
            final isSelected = _selectedTriggers.contains(trigger);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTriggers.remove(trigger);
                  } else {
                    _selectedTriggers.add(trigger);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cardSelectedBg : AppColors.baseWhite,
                  borderRadius: BorderRadius.circular(24), // Rounded pill
                  border: Border.all(
                    color: isSelected ? AppColors.accentCyan : AppColors.borderLightGray,
                    width: isSelected ? 1.5 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.accentCyan.withValues(alpha: 0.1)
                          : const Color(0x040C3C60),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Small leading checkmark icon inside selected active pill
                    if (isSelected) ...[
                      const Icon(
                        Icons.check_rounded,
                        color: AppColors.accentCyan,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      trigger,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.accentCyan : AppColors.slateText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 5. Journal Reflections (Text Area)
  Widget _buildJournalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Journal Reflections',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.slateText,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          minLines: 3,
          maxLines: 5,
          style: const TextStyle(
            color: AppColors.slateText,
            fontSize: 14,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: 'Attended a work dinner... feeling grounded and proud of staying true to my goals.',
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: AppColors.slateMuted,
            ),
            filled: true,
            fillColor: AppColors.baseWhite,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderLightGray, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderLightGray, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accentCyan, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // 5. Gratitude of the Day (Text Area)
  Widget _buildGratitudeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gratitude of the Day',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.slateText,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _gratitudeController,
          minLines: 2,
          maxLines: 4,
          style: const TextStyle(
            color: AppColors.slateText,
            fontSize: 14,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: 'Grateful for supportive friends... and waking up with a clear mind.',
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: AppColors.slateMuted,
            ),
            filled: true,
            fillColor: AppColors.baseWhite,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderLightGray, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderLightGray, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accentCyan, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // 6. Fixed Action Button (Bottom Anchor)
  Widget _buildFixedBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLightGray.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0C3C60),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _saveCheckIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue, // Primary Blue (#0C3C60)
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 12dp rounded corners
            ),
            elevation: 0,
          ),
          child: const Text(
            "Save Today's Check-in",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Challenge",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.slateText,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Daily micro-habits to reinforce your recovery commitment.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slateMuted,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTapDown: (_) => setState(() => _challengeScale = 0.96),
          onTapUp: (_) {
            setState(() {
              _challengeScale = 1.0;
              _isChallengeCompleted = !_isChallengeCompleted;
            });
          },
          onTapCancel: () => setState(() => _challengeScale = 1.0),
          child: AnimatedScale(
            scale: _challengeScale,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: _isChallengeCompleted
                    ? AppColors.cardSelectedBg
                    : AppColors.baseWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isChallengeCompleted
                      ? AppColors.accentCyan
                      : AppColors.borderLightGray,
                  width: _isChallengeCompleted ? 1.8 : 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x060C3C60),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _isChallengeCompleted
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: _isChallengeCompleted
                        ? AppColors.accentCyan
                        : AppColors.slateMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drink 2L of water',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _isChallengeCompleted
                                ? AppColors.primaryBlue
                                : AppColors.slateText,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Hydration reduces physical fatigue and flushes toxins from your body.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.slateMuted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getCravingDescription(int level) {
    if (level <= 2) return 'Very mild or non-existent cravings.';
    if (level <= 4) return 'Occasional thought, manageable without distress.';
    if (level <= 7) return 'Noticeable urge, recommended to use breathing / grounding tools.';
    return 'Severe craving surge — please open the SOS panic toolkit for quick relief!';
  }
}
