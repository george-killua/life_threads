import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/material_route.dart';

void main() {
  testWidgets(
    'iOS: swiping from the left edge goes back',
    (tester) async {
      final router = GoRouter(
        routes: [
          materialRoute(
            path: '/',
            builder: (_, _) =>
                const Scaffold(body: Center(child: Text('HOME'))),
          ),
          materialRoute(
            path: '/next',
            builder: (_, _) =>
                const Scaffold(body: Center(child: Text('NEXT'))),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/next');
      await tester.pumpAndSettle();
      expect(find.text('NEXT'), findsOneWidget);

      final gesture = await tester.startGesture(const Offset(5, 300));
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(40, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('NEXT'), findsNothing);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );
}
