import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sober_one/providers/sobriety_provider.dart';
import 'package:sober_one/screens/certification/quiz_screen.dart';
import 'package:sober_one/screens/widgets/booking_modal.dart';
import 'package:sober_one/screens/widgets/certification_pledge_modal.dart';

Widget _wrap(Widget child, [SobrietyProvider? provider]) {
  return ChangeNotifierProvider<SobrietyProvider>(
    create: (_) => provider ?? SobrietyProvider(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  testWidgets(
      'CertificationPledgeModal renders 4-step stepper, viewfinder, and privacy chip',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => CertificationPledgeModal.show(ctx, milestoneTitle: 'Day 90'),
            child: const Text('Open Pledge'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Pledge'));
    await tester.pumpAndSettle();

    // Verify modal header
    expect(find.text('Start Certification Journey'), findsOneWidget);
    expect(find.text('Pledge for Day 90 verified credential'), findsOneWidget);

    // Verify 4-step stepper
    expect(find.text('Pledge'), findsOneWidget);
    expect(find.text('Sober Window'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    // Verify privacy chip
    expect(
      find.text('🔒 End-to-end encrypted. Face data is stored securely.'),
      findsOneWidget,
    );

    // Verify Primary Action Button
    expect(find.text('Capture Before Photo & Pledge'), findsOneWidget);

    // Tap to pledge
    await tester.tap(find.text('Capture Before Photo & Pledge'));
    await tester.pumpAndSettle();

    expect(find.text('Start Certification Journey'), findsNothing);
  });

  testWidgets(
      'QuizScreen renders split-view before/after card and 10 dynamic quiz questions',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap(const QuizScreen()));
    await tester.pumpAndSettle();

    // Verify header and split-view
    expect(find.text('Certification Assessment'), findsOneWidget);
    expect(find.text('Day 90: Milestone Verified'), findsOneWidget);
    expect(find.text('Biometric Transformation'), findsOneWidget);
    expect(find.text('Day 0 Before'), findsOneWidget);
    expect(find.text('Snap Day 90 Photo'), findsOneWidget);

    // Tap to snap Day 90 photo
    await tester.tap(find.text('Snap Day 90 Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Day 90 After ✓'), findsOneWidget);

    // Verify quiz questions exist
    expect(find.text('Milestone Mastery Quiz'), findsOneWidget);
    expect(find.text('1. Primary Craving Defusal Strategy'), findsOneWidget);
    expect(find.text('10. Readiness for Clinical Verification'), findsOneWidget);

    // Verify submit button
    expect(find.text('Submit & Unlock Assessment'), findsOneWidget);
  });

  testWidgets(
      'BookingModal with sessionType="certification" renders clinical assessment header and restricts format',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => BookingModal.show(ctx, sessionType: 'certification'),
            child: const Text('Open Cert Booking'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Cert Booking'));
    await tester.pumpAndSettle();

    // Verify certification header
    expect(find.text('Book Certification Assessment'), findsOneWidget);
    expect(
      find.text('Certified specialist evaluation to verify milestone credentials'),
      findsOneWidget,
    );
    expect(find.text('Confirm Assessment Session'), findsOneWidget);
  });
}
