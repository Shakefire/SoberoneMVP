import 'package:flutter_test/flutter_test.dart';
import 'package:sober_one/main.dart';

void main() {
  testWidgets('SoberOneApp onboarding smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoberOneApp());
    await tester.pumpAndSettle();

    // Verify Onboarding screen content loads correctly
    expect(find.text('First of all, congrats!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
