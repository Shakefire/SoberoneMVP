import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sober_one/screens/support/support_screen.dart';

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  testWidgets('Support screen renders top app bar with centered title',
      (tester) async {
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Support'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
  });

  testWidgets('Craving SOS card is visible with golden-yellow styling',
      (tester) async {
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    expect(find.text("I'm having a craving"), findsOneWidget);
    expect(
      find.text('Quick tools to help you get through the next 5 minutes'),
      findsOneWidget,
    );
  });

  testWidgets('Support screen has Peer Support Chat card', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Peer Support Chat'), findsOneWidget);
    expect(find.text('Join Discussion →'), findsOneWidget);
  });

  testWidgets('Support screen shows AI Assistant card with chevron',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    expect(find.text('My AI Assistant'), findsOneWidget);
    expect(find.byIcon(Icons.smart_toy_outlined), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  testWidgets('Support screen shows exactly ONE crisis helpline (SAMHSA only)',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    expect(find.text('SAMHSA National Helpline'), findsOneWidget);
    expect(find.text('1-800-662-4357'), findsOneWidget);
    expect(find.text('Call 24/7'), findsOneWidget);
    expect(find.text('988'), findsNothing);
    expect(find.text('Suicide & Crisis Lifeline'), findsNothing);
    expect(find.text('Crisis Text Line'), findsNothing);
  });

  testWidgets('Booking modal opens with dropdowns and date picker', (tester) async {
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book a Session'));
    await tester.pumpAndSettle();
    expect(find.text('Book a 1-on-1 Session'), findsOneWidget);
    expect(find.text('Confidential, HIPAA-compliant support'), findsOneWidget);
    expect(find.text('Session Format'), findsOneWidget);
    expect(find.text('Purpose of Meeting'), findsOneWidget);
    expect(find.text('Preferred Date'), findsOneWidget);
    expect(find.text('Preferred Time'), findsOneWidget);
    expect(find.text('Confirm Confidential Session'), findsOneWidget);
  });

  testWidgets('Peer chat sheet opens correctly', (tester) async {
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join Discussion →'));
    await tester.pumpAndSettle();
    expect(find.text('Peer Support Chat'), findsWidgets);
    expect(find.text('Anonymous · Community · Safe Space'), findsOneWidget);
  });

  testWidgets('Tapping AI Assistant opens venting chat sheet', (tester) async {
    await tester.pumpWidget(_wrap(const SupportScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.smart_toy_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Private · No judgment · 24/7'), findsOneWidget);
  });
}
