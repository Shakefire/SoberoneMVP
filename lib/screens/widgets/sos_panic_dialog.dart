import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SosPanicSheet extends StatefulWidget {
  const SosPanicSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SosPanicSheet(),
    );
  }

  @override
  State<SosPanicSheet> createState() => _SosPanicSheetState();
}

class _SosPanicSheetState extends State<SosPanicSheet>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0: Breathing, 1: Grounding 5-4-3-2-1, 2: Hotlines

  // 4-7-8 Breathing State
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _phaseTimer;
  String _breathPhase = 'Get Ready';
  int _remainingSeconds = 3;
  int _cyclesCompleted = 0;
  bool _isBreathingActive = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _startBreathingCycle() {
    setState(() {
      _isBreathingActive = true;
      _breathPhase = 'Inhale deeply...';
      _remainingSeconds = 4;
    });

    _animController.duration = const Duration(seconds: 4);
    _animController.forward(from: 0.0);

    _runBreathingPhase();
  }

  void _runBreathingPhase() {
    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        if (_breathPhase.startsWith('Inhale')) {
          setState(() {
            _breathPhase = 'Hold your breath...';
            _remainingSeconds = 7;
          });
        } else if (_breathPhase.startsWith('Hold')) {
          setState(() {
            _breathPhase = 'Exhale slowly...';
            _remainingSeconds = 8;
          });
          _animController.duration = const Duration(seconds: 8);
          _animController.reverse(from: 1.0);
        } else if (_breathPhase.startsWith('Exhale')) {
          setState(() {
            _cyclesCompleted++;
            _breathPhase = 'Inhale deeply...';
            _remainingSeconds = 4;
          });
          _animController.duration = const Duration(seconds: 4);
          _animController.forward(from: 0.0);
        }
      }
    });
  }

  void _stopBreathing() {
    _phaseTimer?.cancel();
    _animController.stop();
    setState(() {
      _isBreathingActive = false;
      _breathPhase = 'Get Ready';
      _remainingSeconds = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.88,
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.borderLightGray, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0C3C60),
            blurRadius: 28,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.borderLightGray,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.danger,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Craving SOS Toolkit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'This wave will pass. Take control.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.slateMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.slateText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLightGray, width: 1),
            ),
            child: Row(
              children: [
                _buildTabButton(0, 'Breathing'),
                _buildTabButton(1, 'Sensory'),
                _buildTabButton(2, 'More'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content body
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _selectedTab == 0
                  ? _buildBreathingTab()
                  : _selectedTab == 1
                      ? _buildGroundingTab()
                      : _buildMoreHelpTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_isBreathingActive && index != 0) {
            _stopBreathing();
          }
          setState(() => _selectedTab = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x180C3C60),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.slateMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'The 4-7-8 technique stimulates the parasympathetic nervous system, lowering acute cortisol and craving intensity within 90 seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.slateText,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 32),

          // Visual Circle
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accentCyan.withValues(alpha: 0.22),
                          AppColors.primaryBlue.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardSelectedBg,
                    border: Border.all(
                      color: _isBreathingActive
                          ? AppColors.accentCyan
                          : AppColors.borderLightGray,
                      width: 3.5,
                    ),
                    boxShadow: _isBreathingActive
                        ? [
                            BoxShadow(
                              color: AppColors.accentCyan.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ]
                        : const [
                            BoxShadow(
                              color: Color(0x080C3C60),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isBreathingActive ? '$_remainingSeconds' : '4-7-8',
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _breathPhase,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _isBreathingActive
                              ? AppColors.accentCyan
                              : AppColors.slateMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Cycles completed: $_cyclesCompleted',
            style: const TextStyle(
              color: AppColors.slateMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Control Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isBreathingActive ? _stopBreathing : _startBreathingCycle,
              icon: Icon(_isBreathingActive ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(_isBreathingActive ? 'Pause Exercise' : 'Start 4-7-8 Breathing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBreathingActive ? AppColors.danger : AppColors.primaryBlue,
                foregroundColor: AppColors.baseWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGroundingTab() {
    final steps = [
      {'num': '5', 'title': 'See', 'desc': 'Look around and name 5 distinct things you see right now.'},
      {'num': '4', 'title': 'Feel', 'desc': 'Notice 4 physical textures (your clothes, chair, watch, floor).'},
      {'num': '3', 'title': 'Hear', 'desc': 'Listen closely and identify 3 ambient sounds around you.'},
      {'num': '2', 'title': 'Smell', 'desc': 'Inhale through your nose and detect 2 scents in the air.'},
      {'num': '1', 'title': 'Taste', 'desc': 'Sip water or notice the current taste in your mouth.'},
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        const Text(
          'The 5-4-3-2-1 Sensory Grounding',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Engaging all 5 senses anchors your mind in reality, breaking craving loops.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.slateMuted,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.map((step) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLightGray, width: 1.5),
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
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cardSelectedBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.35),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step['num']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step['desc']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.slateText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  // SAFETY: No crisis phone numbers here. All crisis contacts live exclusively on the Support page.
  Widget _buildMoreHelpTab() {
    final tips = [
      ('🚶', 'Go for a 10-minute walk', 'Physical movement rapidly reduces craving intensity.'),
      ('🧊', 'Hold ice in your hand', 'Cold sensation interrupts the urge signal in your brain.'),
      ('📞', 'Call someone you trust', 'Even a short chat shifts your focus and eases isolation.'),
      ('📝', 'Write it out', 'Journal the craving as if you are an outside observer watching it pass.'),
      ('🎵', 'Play your recovery playlist', 'Music you associate with strength anchors positive emotion.'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        const Text(
          'More Coping Tools',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quick evidence-based actions to ride out this wave.',
          style: TextStyle(fontSize: 13, color: AppColors.slateMuted),
        ),
        const SizedBox(height: 16),
        ...tips.map((tip) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLightGray, width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.$1, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.$2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tip.$3,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.slateMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        // Soft redirect — no phone numbers, just navigation cue
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardSelectedBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.accentCyan.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.health_and_safety_rounded,
                color: AppColors.accentCyan,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need professional support?',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Close this and open the Support tab to connect with a specialist or the National Helpline.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.slateMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
