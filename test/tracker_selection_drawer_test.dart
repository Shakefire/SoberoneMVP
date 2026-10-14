import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sober_one/providers/sobriety_provider.dart';
import 'package:sober_one/screens/widgets/tracker_selection_drawer.dart';

Widget _buildTestApp({Widget? child}) {
  return ChangeNotifierProvider(
    create: (_) => SobrietyProvider(),
    child: MaterialApp(
      home: Scaffold(
        drawer: child ?? const TrackerSelectionDrawer(),
        body: Builder(
          builder: (scaffoldContext) => Center(
            child: ElevatedButton(
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              child: const Text('Open Drawer'),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('TrackerSelectionDrawer renders all components according to spec',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Open the drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // 1. Verify Drawer Container is open
    expect(find.byType(TrackerSelectionDrawer), findsOneWidget);

    // 2. Active Tracker Card
    // Top Half: Active substance name ("Alcohol" by default in SobrietyProvider)
    expect(find.text('Alcohol'), findsOneWidget);
    // Generic substance hexagon icon + checkmark icon
    expect(find.byIcon(Icons.hexagon_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Divider
    expect(find.byType(Divider), findsOneWidget);

    // Bottom Half: "Sober for:" and duration text
    expect(find.text('Sober for:'), findsOneWidget);
    // Duration is "14 days" by default in SobrietyProvider or "X days"
    expect(find.textContaining('day'), findsWidgets);

    // 3. Tracker Action Row
    // Action 1: Add New
    expect(find.text('Add New'), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    // Action 2: Edit List
    expect(find.text('Edit List'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // 4. Informational Text Block
    expect(
      find.text('With Sober Plus, you can add more trackers as you need them.'),
      findsOneWidget,
    );

    // Footer Icon
    expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
  });

  testWidgets('Tapping Add New opens add tracker modal', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add New'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tracker'), findsOneWidget);
    expect(find.text('Choose a habit or substance to track:'), findsOneWidget);
  });

  testWidgets('Tapping Edit List opens edit tracker modal', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit List'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Current Tracker'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });
}
