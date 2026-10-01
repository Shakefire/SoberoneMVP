import 'package:flutter_test/flutter_test.dart';
import 'package:sober_one/main.dart';

void main() {
  testWidgets('SoberOneApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoberOneApp());
    await tester.pumpAndSettle();

    // Verify that the title and core navigation render
    expect(find.text('SoberOne'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
  });
}
