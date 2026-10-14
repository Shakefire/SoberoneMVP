import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sober_one/providers/sobriety_provider.dart';
import 'package:sober_one/screens/rewards/rewards_dashboard.dart';
import 'package:sober_one/screens/widgets/tracker_selection_drawer.dart';

Widget _wrap(Widget child, [SobrietyProvider? provider]) {
  final p = provider ?? SobrietyProvider();
  return ChangeNotifierProvider<SobrietyProvider>.value(
    value: p,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  testWidgets(
      'NavigationDrawer displays Reformed Rewards item (locked vs unlocked)',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = SobrietyProvider();

    await tester.pumpWidget(
      _wrap(
        Scaffold(
          drawer: const TrackerSelectionDrawer(),
          body: Builder(
            builder: (ctx) => Center(
              child: ElevatedButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                child: const Text('Open Drawer'),
              ),
            ),
          ),
        ),
        provider,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // Verify Reformed Rewards item is visible and initially locked
    expect(find.text('Reformed Rewards'), findsOneWidget);
    expect(find.text('Locked · Clinical verification required'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);

    // Now pass assessment in provider
    provider.passAssessment();
    await tester.pumpAndSettle();

    // Verify item is now unlocked with star/award icon
    expect(find.text('Grants & Opportunities Unlocked ★'), findsOneWidget);
    expect(find.byIcon(Icons.military_tech_rounded), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    provider.dispose();
  });

  testWidgets(
      'RewardsDashboard renders Opportunities grants and My Applications tabs',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = SobrietyProvider();
    provider.passAssessment();

    await tester.pumpWidget(_wrap(const RewardsDashboard(), provider));
    await tester.pumpAndSettle();

    // Verify top app bar
    expect(find.text('Reformed Rewards'), findsOneWidget);
    expect(find.text('Administrative Grants & Capital Allocation'), findsOneWidget);

    // Verify Tab 1: Opportunities grants
    expect(find.text('Small Business Capital'), findsOneWidget);
    expect(find.text('Tech Empowerment'), findsOneWidget);
    expect(find.text('Education Fund'), findsOneWidget);
    expect(find.text('Artisan & Trade Starter'), findsOneWidget);

    // Switch to Tab 2: My Applications
    await tester.tap(find.text('My Applications'));
    await tester.pumpAndSettle();

    // Initial mock application exists
    expect(find.text('Under Review'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    provider.dispose();
  });
}
