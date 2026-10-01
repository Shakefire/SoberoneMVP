import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.88,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
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
                        color: AppColors.danger.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.danger,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Craving SOS Toolkit',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'This wave will pass. Take control.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
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
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _buildTabButton(0, '4-7-8 Breathing', Icons.air_rounded),
                _buildTabButton(1, '5-4-3-2-1 Grounding', Icons.spa_rounded),
                _buildTabButton(2, 'Hotlines', Icons.phone_in_talk_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content body
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _selectedTab == 0
                  ? _buildBreathingTab(theme)
                  : _selectedTab == 1
                      ? _buildGroundingTab(theme)
                      : _buildHotlinesTab(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
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
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondaryDark,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'The 4-7-8 technique stimulates the parasympathetic nervous system, lowering acute cortisol and craving intensity within 90 seconds.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryDark,
              height: 1.4,
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
                          AppColors.primary.withAlpha(50),
                          AppColors.secondary.withAlpha(20),
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
                    color: AppColors.surfaceDark,
                    border: Border.all(
                      color: _isBreathingActive
                          ? AppColors.primary
                          : AppColors.borderDark,
                      width: 3,
                    ),
                    boxShadow: _isBreathingActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(80),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isBreathingActive ? '$_remainingSeconds' : '4-7-8',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _breathPhase,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isBreathingActive
                              ? AppColors.primaryLight
                              : AppColors.textSecondaryDark,
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
              color: AppColors.textMutedDark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // Control Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBreathingActive ? _stopBreathing : _startBreathingCycle,
              icon: Icon(_isBreathingActive ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(_isBreathingActive ? 'Pause Exercise' : 'Start 4-7-8 Breathing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBreathingActive ? AppColors.danger : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGroundingTab(ThemeData theme) {
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
        Text(
          'The 5-4-3-2-1 Sensory Grounding',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Engaging all 5 senses anchors your mind in reality, breaking craving loops.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.map((step) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step['num']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step['desc']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryDark,
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

  Widget _buildHotlinesTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        Text(
          'Free & Confidential Crisis Support',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'You are never alone. Professional counselors are available 24 hours a day, 365 days a year.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(height: 16),
        ...AppConstants.emergencyHotlines.map((hotline) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotline['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '24/7 Available',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  hotline['description']!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDarkLight.withAlpha(80),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            hotline['number']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Tap to dial',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMutedDark,
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
}
