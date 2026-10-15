import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_colors.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/core/widgets/app_toast.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    return captured;
  }

  testWidgets('shows the message and closes with the X button', (
    tester,
  ) async {
    final context = await pumpHost(tester);

    context.showToast('Saved.', kind: ToastKind.success);
    await tester.pumpAndSettle();
    expect(find.text('Saved.'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Saved.'), findsNothing);
  });

  testWidgets('runs the action and closes', (tester) async {
    final context = await pumpHost(tester);
    var deleted = false;

    context.showToast(
      'Link ready.',
      action: ToastAction(label: 'Delete', onPressed: () => deleted = true),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleted, isTrue);
    expect(find.text('Link ready.'), findsNothing);
  });

  testWidgets('errors use the error colour and stay longer', (tester) async {
    final context = await pumpHost(tester);

    context.showToast('Could not save.', kind: ToastKind.error);
    await tester.pumpAndSettle();

    final icon = tester.widget<Icon>(find.byIcon(Icons.priority_high_rounded));
    expect(icon.color, AppColors.error);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Could not save.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Could not save.'), findsNothing);
  });

  test('toasts with an action stay longest', () {
    final toast = appToast(
      'Link ready.',
      action: ToastAction(label: 'Delete', onPressed: () {}),
    );
    expect(toast.duration, const Duration(seconds: 9));
    expect(appToast('Hi').duration, const Duration(seconds: 4));
  });
}
