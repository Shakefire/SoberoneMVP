import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sober_one/providers/check_in_provider.dart';
import 'package:sober_one/screens/tracker/check_in_screen.dart';

void main() {
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckInProvider()),
      ],
      child: const MaterialApp(
        home: CheckInScreen(),
      ),
    );
  }

  testWidgets('CheckInScreen renders all 6 sections correctly according to design specs',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // 1. Top App Bar: back arrow & title "Daily Check-In"
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Daily Check-In'), findsOneWidget);

    // 2. Mood Section
    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(
      find.text('Check in honestly with your emotional baseline.'),
      findsOneWidget,
    );
    expect(find.text('Great'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Neutral'), findsOneWidget);
    expect(find.text('Low'), findsOneWidget);
    expect(find.text('Struggling'), findsOneWidget);

    // 3. Craving Intensity Section
    expect(find.text('Craving Intensity'), findsOneWidget);
    expect(find.text('2 / 10'), findsOneWidget);
    expect(find.text('Very mild or non-existent cravings.'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    // 4. Triggers Section (Wrapping Flexbox with checkmarks for selected)
    expect(find.text('Were you triggered by anything?'), findsOneWidget);
    expect(
      find.text('Select any triggers that influenced you today.'),
      findsOneWidget,
    );
    expect(find.text('Social Gathering'), findsOneWidget);
    expect(find.text('Fatigue / Exhaustion'), findsOneWidget);
    expect(find.text('Stress'), findsOneWidget);
    // Initial selection should have checkmark icons
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

    // 5. Journal & Gratitude Sections
    expect(find.text('Journal Reflections'), findsOneWidget);
    expect(
      find.text('Attended a work dinner... feeling grounded and proud of staying true to my goals.'),
      findsOneWidget,
    );
    expect(find.text('Gratitude of the Day'), findsOneWidget);
    expect(
      find.text('Grateful for supportive friends... and waking up with a clear mind.'),
      findsOneWidget,
    );

    // 6. Fixed Action Button (Bottom Anchor)
    expect(find.text("Save Today's Check-in"), findsOneWidget);
  });

  testWidgets('Toggling mood and triggers updates selection state correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Select "Great" mood
    await tester.tap(find.text('Great'));
    await tester.pumpAndSettle();

    // Toggle a trigger (tap "Stress")
    await tester.tap(find.text('Stress'));
    await tester.pumpAndSettle();

    // Now 3 checkmarks should be visible
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(3));
  });

  testWidgets('Tapping Save Today\'s Check-in triggers save action',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final saveButton = find.text("Save Today's Check-in");
    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // SnackBar should be displayed
    expect(find.text('Check-in saved! Keep up the incredible work.'), findsOneWidget);
  });
}
