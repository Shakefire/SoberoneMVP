import 'dart:math';
import 'package:flutter/material.dart';
import '../main_navigation_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
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
        return Container(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0F1535),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0x33FFFFFF), width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to restore your sobriety milestones and journal data.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60),
                  filled: true,
                  fillColor: const Color(0xFF1A2148),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF2CB1F5)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _navigateToHome(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CB1F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Restore & Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom Painted Mountains & Gradient Sky
          Positioned.fill(
            child: CustomPaint(
              painter: _MountainLandscapePainter(),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Overlapping Diamonds Graphic
                  const _OverlappingDiamonds(),

                  const Spacer(flex: 4),

                  // Typography section
                  const Text(
                    "First of all, congrats!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You've just taken a big step on the path to\nsobriety.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 44),

                  // Primary Action Button: "Get Started"
                  ElevatedButton(
                    onPressed: () => _navigateToHome(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A2FE),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Secondary Action Prompt
                  Text(
                    "Returning user with data to restore?",
                    style: TextStyle(
                      color: Colors.white.withAlpha(160),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Secondary Action Button: "Sign In"
                  OutlinedButton(
                    onPressed: () => _showSignInSheet(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white.withAlpha(40),
                        width: 1,
                      ),
                      backgroundColor: const Color(0xFF0B143A).withAlpha(100),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xFF2CB1F5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlappingDiamonds extends StatelessWidget {
  const _OverlappingDiamonds();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Diamond (rendered in background layer)
          Transform.translate(
            offset: const Offset(0, -56),
            child: const _DiamondShape(opacity: 0.10),
          ),
          // Middle Diamond
          const _DiamondShape(opacity: 0.13),
          // Bottom Diamond
          Transform.translate(
            offset: const Offset(0, 56),
            child: const _DiamondShape(opacity: 0.16),
          ),
        ],
      ),
    );
  }
}

class _DiamondShape extends StatelessWidget {
  final double opacity;

  const _DiamondShape({this.opacity = 0.12});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 4, // 45 degrees in radians
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((opacity * 255).round()),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withAlpha((opacity * 1.5 * 255).clamp(0, 255).round()),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to generate the mountain landscape and sky gradient exactly as in the reference design
class _MountainLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Sky Gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1E6CBE), // Vibrant cobalt blue at the top
          Color(0xFF38689E), // Mid-sky
          Color(0xFF676196), // Soft lavender purple layer
          Color(0xFF4C4D7E), // Atmospheric blend
          Color(0xFF1F2B56), // Deep dusk
          Color(0xFF0B1435), // Night base
        ],
        stops: [0.0, 0.22, 0.48, 0.62, 0.82, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // 2. Far Background Mountains (Soft purple haze)
    final farMountainPath = Path();
    farMountainPath.moveTo(0, size.height * 0.52);
    farMountainPath.cubicTo(
      size.width * 0.25,
      size.height * 0.49,
      size.width * 0.45,
      size.height * 0.58,
      size.width * 0.72,
      size.height * 0.52,
    );
    farMountainPath.cubicTo(
      size.width * 0.85,
      size.height * 0.49,
      size.width * 0.95,
      size.height * 0.51,
      size.width,
      size.height * 0.53,
    );
    farMountainPath.lineTo(size.width, size.height);
    farMountainPath.lineTo(0, size.height);
    farMountainPath.close();

    final farMountainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4C4576).withAlpha(120),
          const Color(0xFF1E2856).withAlpha(180),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.48, size.width, size.height * 0.52));

    canvas.drawPath(farMountainPath, farMountainPaint);

    // 3. Midground Mountains (Deep ocean slate ridge sloping down from right)
    final midMountainPath = Path();
    midMountainPath.moveTo(size.width, size.height * 0.55);
    midMountainPath.cubicTo(
      size.width * 0.80,
      size.height * 0.60,
      size.width * 0.60,
      size.height * 0.68,
      size.width * 0.40,
      size.height * 0.65,
    );
    midMountainPath.cubicTo(
      size.width * 0.25,
      size.height * 0.62,
      size.width * 0.10,
      size.height * 0.68,
      0,
      size.height * 0.72,
    );
    midMountainPath.lineTo(0, size.height);
    midMountainPath.lineTo(size.width, size.height);
    midMountainPath.close();

    final midMountainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF22436F).withAlpha(180),
          const Color(0xFF12244E).withAlpha(220),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45));

    canvas.drawPath(midMountainPath, midMountainPaint);

    // 4. Foreground Left Mountain Ridge (Sloping down from left to center)
    final fgLeftPath = Path();
    fgLeftPath.moveTo(0, size.height * 0.62);
    fgLeftPath.cubicTo(
      size.width * 0.15,
      size.height * 0.68,
      size.width * 0.35,
      size.height * 0.76,
      size.width * 0.65,
      size.height * 0.84,
    );
    fgLeftPath.cubicTo(
      size.width * 0.85,
      size.height * 0.88,
      size.width * 0.95,
      size.height * 0.86,
      size.width,
      size.height * 0.88,
    );
    fgLeftPath.lineTo(size.width, size.height);
    fgLeftPath.lineTo(0, size.height);
    fgLeftPath.close();

    final fgLeftPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF173867).withAlpha(230),
          const Color(0xFF091432).withAlpha(250),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38));

    canvas.drawPath(fgLeftPath, fgLeftPaint);

    // 5. Deep Foreground Right Valley Ridge
    final fgRightPath = Path();
    fgRightPath.moveTo(size.width, size.height * 0.64);
    fgRightPath.cubicTo(
      size.width * 0.82,
      size.height * 0.72,
      size.width * 0.65,
      size.height * 0.82,
      size.width * 0.45,
      size.height * 0.88,
    );
    fgRightPath.cubicTo(
      size.width * 0.25,
      size.height * 0.94,
      size.width * 0.10,
      size.height * 0.92,
      0,
      size.height * 0.95,
    );
    fgRightPath.lineTo(0, size.height);
    fgRightPath.lineTo(size.width, size.height);
    fgRightPath.close();

    final fgRightPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0D254F),
          Color(0xFF050D24),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.64, size.width, size.height * 0.36));

    canvas.drawPath(fgRightPath, fgRightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
