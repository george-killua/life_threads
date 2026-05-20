import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding before first wall visit', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();

    expect(find.text('Build your living wall.'), findsOneWidget);
    expect(
      find.text(
        'Your memories stay private: no account and no cloud upload in this MVP.',
      ),
      findsOneWidget,
    );
  });
}
