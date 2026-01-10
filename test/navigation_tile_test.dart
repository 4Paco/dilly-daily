import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Account/NavigationTile.dart';
import 'package:dilly_daily/pages/Account/AccountSubPageScaffold.dart';

void main() {
  group('NavigationTile', () {
    testWidgets('displays title and navigates on tap', (tester) async {
      final item = {
        'title': 'Test Page',
        'page': const Text('Page Content'),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationTile(
              item: item,
              leading: const Icon(Icons.star),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      );

      // Tap the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(AccountSubPageScaffold), findsOneWidget);
      expect(find.text('Test Page'), findsOneWidget);
      expect(find.text('Page Content'), findsOneWidget);
    });
  });
}
