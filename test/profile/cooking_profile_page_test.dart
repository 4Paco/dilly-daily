import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/pages/Account/CookingProfile/cooking_profile_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CookingProfilePage Widget Tests', () {
    setUp(() {
      personals.defaultPersonNumber = 2;
      personals.patience = 0.5;
    });

    testWidgets('slider updates patience value', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: CookingProfilePage()),
          ),
        );

        final slider = find.byType(Slider);
        expect(slider, findsOneWidget);

        await tester.drag(slider, const Offset(300, 0));
        await tester.pumpAndSettle();

        expect(personals.patience, greaterThanOrEqualTo(0.1));
        expect(personals.patience, lessThanOrEqualTo(0.9));
      });
    });
  });
}

