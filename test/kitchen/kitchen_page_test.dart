import 'package:dilly_daily/data/personalisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Account/Kitchen/KitchenPage.dart';

void main() {
  testWidgets('renders all kitchen gear items', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: KitchenPage()),
    );

    expect(find.text('Oven'), findsOneWidget);
    expect(find.text('Mixer'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(4));
  });

  testWidgets('tapping checkbox updates value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: KitchenPage()),
    );

    final checkbox = find.byType(Checkbox).first;

    Checkbox cb = tester.widget(checkbox);
    expect(cb.value, false);

    await tester.tap(checkbox);
    await tester.pump();

    cb = tester.widget(checkbox);
    expect(cb.value, true);
  });


  testWidgets('save button shows snackbar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: KitchenPage()),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.text('Profile updated and saved!'),
      findsOneWidget,
    );

  });

    testWidgets('saving updates user profile kitchen gear', (tester) async {
      personals.kitchenGear = []; // reset state

      await tester.pumpWidget(
        const MaterialApp(home: KitchenPage()),
      );

      // Tap first checkbox (must be Oven)
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      // Tap save
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(personals.kitchenGear, contains('Oven'));
    });
}



