import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sober_one/providers/check_in_provider.dart';
import 'package:sober_one/screens/tracker/check_in_screen.dart';

Widget _createTestWidget() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CheckInProvider()),
    ],
    child: const MaterialApp(
      home: CheckInScreen(),
    ),
  );
}

void main() {
  testWidgets('Daily Check-In renders Today\'s Challenge block and toggles state',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_createTestWidget());
    await tester.pumpAndSettle();

    // Verify "Today's Challenge" header
    expect(find.text("Today's Challenge"), findsOneWidget);
    expect(find.text('Drink 2L of water'), findsOneWidget);

    // Initial state: unchecked checkbox icon
    expect(find.byIcon(Icons.check_box_outline_blank_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_box_rounded), findsNothing);

    // Tap challenge card to toggle
    await tester.ensureVisible(find.text('Drink 2L of water'));
    await tester.tap(find.text('Drink 2L of water'));
    await tester.pumpAndSettle();

    // Checked state: check box filled
    expect(find.byIcon(Icons.check_box_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outline_blank_rounded), findsNothing);
  });

  testWidgets(
      'Saving check-in with challenge completed triggers Badge Earned popup modal',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_createTestWidget());
    await tester.pumpAndSettle();

    // Complete challenge
    await tester.ensureVisible(find.text('Drink 2L of water'));
    await tester.tap(find.text('Drink 2L of water'));
    await tester.pumpAndSettle();

    // Tap Save Today's Check-in
    await tester.ensureVisible(find.text("Save Today's Check-in"));
    await tester.tap(find.text("Save Today's Check-in"));
    await tester.pumpAndSettle();

    // Verify Badge Earned modal is triggered
    expect(find.text('Badge Earned!'), findsOneWidget);
    expect(find.text('Hydration Champion'), findsOneWidget);
    expect(find.byIcon(Icons.military_tech_rounded), findsOneWidget);
    expect(find.text('Claim & Return to Dashboard'), findsOneWidget);

    // Tap Claim button
    await tester.tap(find.text('Claim & Return to Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Badge Earned!'), findsNothing);
  });
}
