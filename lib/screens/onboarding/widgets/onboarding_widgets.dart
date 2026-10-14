import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Segmented Progress Bar
/// Completed segments: Primary Blue (#0C3C60)
/// Current segment: Gently pulses with Accent Cyan (#0098B8)
/// Upcoming segments: Muted border gray (#CBD5E1)
class SegmentedProgressBar extends StatefulWidget {
  final int totalSegments;
  final int currentSegment;

  const SegmentedProgressBar({
    super.key,
    required this.totalSegments,
    required this.currentSegment,
  });

  @override
  State<SegmentedProgressBar> createState() => _SegmentedProgressBarState();
}

class _SegmentedProgressBarState extends State<SegmentedProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Row(
          children: List.generate(widget.totalSegments, (index) {
            final isCompleted = index < widget.currentSegment;
            final isCurrent = index == widget.currentSegment;

            Color segmentColor;
            if (isCompleted) {
              segmentColor = AppColors.primaryBlue;
            } else if (isCurrent) {
              segmentColor =
                  AppColors.accentCyan.withValues(alpha: _pulseAnimation.value);
            } else {
              segmentColor = AppColors.borderLightGray;
            }

            return Expanded(
              child: Container(
                height: 5,
                margin: EdgeInsets.only(
                  right: index == widget.totalSegments - 1 ? 0 : 6,
                ),
                decoration: BoxDecoration(
                  color: segmentColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(
                                alpha: 0.4 * _pulseAnimation.value),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// The Tactile Selection Card (High Contrast)
/// - Default: Base White (#FFFFFF), 1.5dp defined border (#CBD5E1), soft blue-tinted shadow.
///   Clear circular indicator on the right showing it is selectable.
/// - Active: 2.5dp Accent Cyan border (#0098B8), soft Cyan tint background (#EFF9FB),
///   solid Cyan checkmark badge.
/// - Micro-interaction: Tapping triggers slight scale-down animation (0.98x) for 150ms.
class SelectionCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? emoji;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showCheckmark;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.emoji,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.showCheckmark = true,
  });

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.98,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _pressController;
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _pressController.reverse();
  }

  void _handleTapUp(TapUpDetails _) {
    _pressController.forward();
    widget.onTap();
  }

  void _handleTapCancel() {
    _pressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cardSelectedBg : AppColors.baseWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentCyan
                    : AppColors.borderLightGray,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.accentCyan.withValues(alpha: 0.18)
                      : const Color(0x0F0C3C60),
                  offset: const Offset(0, 3),
                  blurRadius: isSelected ? 10 : 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.emoji != null) ...[
                  Text(
                    widget.emoji!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                ] else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 24,
                    color: isSelected
                        ? AppColors.accentCyan
                        : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 16.5,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.slateText
                                : AppColors.slateMuted,
                            fontSize: 13.5,
                            height: 1.45,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showCheckmark) ...[
                  const SizedBox(width: 14),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.accentCyan
                          : AppColors.baseWhite,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentCyan
                            : AppColors.borderLightGray,
                        width: 2.0,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Multi-Select & Single-Select Tactile Pill (High Contrast)
/// - Default: Base White (#FFFFFF), 1.5dp border (#CBD5E1), deep Primary Blue text (#0C3C60).
/// - Selected: Fills with Primary Blue (#0C3C60), Base White text (#FFFFFF).
/// - Micro-interaction: Tapping scales down to 0.97x for 120ms.
class TactilePill extends StatefulWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final bool disabled;

  const TactilePill({
    super.key,
    required this.label,
    this.emoji,
    required this.isSelected,
    required this.onTap,
    this.disabled = false,
  });

  @override
  State<TactilePill> createState() => _TactilePillState();
}

class _TactilePillState extends State<TactilePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: widget.disabled ? 0.35 : 1.0,
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => _scaleController.reverse(),
        onTapUp: widget.disabled
            ? null
            : (_) {
                _scaleController.forward();
                widget.onTap();
              },
        onTapCancel: widget.disabled ? null : () => _scaleController.forward(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : AppColors.baseWhite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.borderLightGray,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.25),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ]
                  : [
                      const BoxShadow(
                        color: Color(0x0C0C3C60),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.emoji != null) ...[
                  Text(widget.emoji!, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.baseWhite
                        : AppColors.primaryBlue,
                    fontSize: 14.5,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Conversational Section Header Anchor (High Contrast)
/// Primary Blue (#0C3C60) title, deep Slate Text (#1E293B) subtitle with 145% line height.
/// 24dp margin between subtitle and interactive elements.
class ConversationalHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCentered;

  const ConversationalHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            color: AppColors.slateText,
            fontSize: 15,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Primary Onboarding CTA Button (High Contrast)
/// Deep Primary Blue (#0C3C60) background, bold sans-serif text in Base White,
/// arrow icon locked to the far-right edge with 24dp padding.
class OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  const OnboardingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1.0 : 0.40,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            disabledBackgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.baseWhite,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.baseWhite,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.baseWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Back Button for top navigation
class OnboardingBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const OnboardingBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.baseWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLightGray, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0C3C60),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.primaryBlue,
          size: 20,
        ),
      ),
    );
  }
}

/// Floating-Label Text Input (High Contrast)
class TactileTextInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const TactileTextInput({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.onChanged,
  });

  @override
  State<TactileTextInput> createState() => _TactileTextInputState();
}

class _TactileTextInputState extends State<TactileTextInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? AppColors.accentCyan.withValues(alpha: 0.15)
                : const Color(0x0C0C3C60),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(
            color: _isFocused ? AppColors.accentCyan : AppColors.primaryBlue,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: const TextStyle(
            color: AppColors.slateMuted,
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppColors.baseWhite,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.borderLightGray,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.accentCyan,
              width: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tactile Dropdown Selector (High Contrast)
class TactileDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const TactileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLightGray, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0C3C60),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: AppColors.baseWhite,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primaryBlue,
            size: 24,
          ),
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
