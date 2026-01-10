import 'package:dilly_daily/pages/Account/CookingProfile/cooking_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Account/account_page.dart';
import 'package:dilly_daily/pages/Account/AccountSubPageScaffold.dart';

void main() {
  group('AccountPage Widget Tests', () {
    testWidgets('displays user info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AccountPage())),
      );

      // Check user name
      expect(find.text('Louise Baril'), findsOneWidget);

      // Check email
      expect(find.text('marie.sue@example.com'), findsOneWidget);
    });

      testWidgets('displays all account submenu items', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 1000, // tall enough to show all items
                child: AccountPage(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Each AccountSubmenu title should appear
        final titles = [
          'Special diet',
          'My cooking profile',
          'My favorite meals',
          'My kitchen',
          'My friends',
          'Notifications',
          'Help'
        ];

      for (final title in titles) {
        expect(find.text(title), findsOneWidget);
      }
    });


    testWidgets('navigates to CookingProfilePage via submenu', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AccountPage())),
      );

      // Tap the cooking profile menu
      final tile = find.text('My cooking profile');
      expect(tile, findsOneWidget);

      await tester.tap(tile);
      await tester.pumpAndSettle();

      // Check navigation
      expect(find.byType(AccountSubPageScaffold), findsOneWidget);
      expect(find.text('My cooking profile'), findsOneWidget);
      expect(find.byType(CookingProfilePage), findsOneWidget);
    });
  });
}
