import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sobriety_provider.dart';

class CertificationPledgeModal extends StatefulWidget {
  final String milestoneTitle;

  const CertificationPledgeModal({
    super.key,
    required this.milestoneTitle,
  });

  static void show(BuildContext context, {String milestoneTitle = 'Day 90'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CertificationPledgeModal(milestoneTitle: milestoneTitle),
    );
  }

  @override
  State<CertificationPledgeModal> createState() =>
      _CertificationPledgeModalState();
}

class _CertificationPledgeModalState extends State<CertificationPledgeModal> {
  bool _isPhotoCaptured = false;
  String _simulatedPhotoName = 'before_pledge_selfie.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start Certification Journey',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Pledge for ${widget.milestoneTitle} verified credential',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.slateMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.slateMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLightGray),

          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Horizontal 4-step progress stepper
                  _buildStepper(),
                  const SizedBox(height: 24),

                  // 2. Camera Viewfinder Block with dashed face-framing overlay
                  _buildCameraViewfinder(),
                  const SizedBox(height: 16),

                  // 3. Privacy Chip
                  _buildPrivacyChip(),
                  const SizedBox(height: 24),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.softSurfaceGray,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLightGray),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: AppColors.accentCyan,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your baseline "Before" photo will be encrypted locally and compared at day 90 to celebrate your biometric transformation.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.slateText,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.baseWhite,
              border: Border(top: BorderSide(color: AppColors.borderLightGray)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  final provider = context.read<SobrietyProvider>();
                  provider.pledgeCertification(
                    milestone: widget.milestoneTitle,
                    photoPath: _simulatedPhotoName,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.accentCyan),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pledge recorded for ${widget.milestoneTitle}! Baseline photo securely encrypted.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 18),
                label: Text(
                  _isPhotoCaptured
                      ? 'Confirm Photo & Complete Pledge'
                      : 'Capture Before Photo & Pledge',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Horizontal 4-step progress stepper
  Widget _buildStepper() {
    final steps = [
      {'num': '1', 'label': 'Pledge'},
      {'num': '2', 'label': 'Sober Window'},
      {'num': '3', 'label': 'Quiz'},
      {'num': '4', 'label': 'Review'},
    ];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          return Expanded(
            child: Container(
              height: 2,
              color: index == 1
                  ? AppColors.accentCyan
                  : AppColors.borderLightGray,
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final step = steps[stepIndex];
        final isActive = stepIndex == 0; // Currently on Step 1: Pledge

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primaryBlue
                    : AppColors.softSurfaceGray,
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.borderLightGray,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  step['num']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isActive ? Colors.white : AppColors.slateMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              step['label']!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primaryBlue : AppColors.slateMuted,
              ),
            ),
          ],
        );
      }),
    );
  }

  // 2. Camera Viewfinder with dashed face-framing overlay
  Widget _buildCameraViewfinder() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPhotoCaptured = !_isPhotoCaptured;
          if (_isPhotoCaptured) {
            _simulatedPhotoName = 'selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';
          }
        });
      },
      child: Container(
        height: 230,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Dark camera viewfinder chamber
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLightGray, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient camera grid background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      const Color(0xFF1E293B),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Dashed face framing oval overlay
            CustomPaint(
              size: const Size(160, 200),
              painter: _DashedOvalPainter(
                color: _isPhotoCaptured ? AppColors.accentCyan : Colors.white70,
              ),
            ),

            // Content inside viewfinder
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPhotoCaptured
                      ? Icons.check_circle_rounded
                      : Icons.face_retouching_natural_rounded,
                  color: _isPhotoCaptured
                      ? AppColors.accentCyan
                      : Colors.white70,
                  size: 42,
                ),
                const SizedBox(height: 10),
                Text(
                  _isPhotoCaptured
                      ? 'Selfie Captured Locally'
                      : 'Align Face Within Oval',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isPhotoCaptured
                      ? 'Tap viewfinder to retake'
                      : 'Tap anywhere to snap baseline photo',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),

            // Viewfinder corner marks
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'REC · 1080P',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Privacy chip
  Widget _buildPrivacyChip() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.softSurfaceGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLightGray),
        ),
        child: const Text(
          '🔒 End-to-end encrypted. Face data is stored securely.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.slateMuted,
          ),
        ),
      ),
    );
  }
}

// Dashed Oval Painter for face alignment framing
class _DashedOvalPainter extends CustomPainter {
  final Color color;

  const _DashedOvalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.85,
      height: size.height * 0.88,
    );

    final path = Path()..addOval(rect);

    // Draw dashed path
    const dashLength = 7.0;
    const gapLength = 5.0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        final extractPath = metric.extractPath(
          distance,
          next > metric.length ? metric.length : next,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedOvalPainter oldDelegate) =>
      oldDelegate.color != color;
}
