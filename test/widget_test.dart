import 'package:flutter_test/flutter_test.dart';
import 'package:sober_one/main.dart';

void main() {
  testWidgets('SoberOneApp onboarding and navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoberOneApp());
    await tester.pumpAndSettle();

    // Verify Onboarding screen content
    expect(find.text('First of all, congrats!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Tap "Get Started" and verify navigation into main app
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('SoberOne'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
  });
}
