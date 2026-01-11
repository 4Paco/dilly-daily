import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/pages/Explore/explore_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Explore filters – unit tests (Map-based)', () {
    test('filters out recipes with disliked ingredients', () {
      final result = recettesFiltrees({
        'food': true,
        'kitchen': false,
        'energy': false,
      }).map((e) => e.key).toList();
      expect(result, isNot(contains('tomatoTest')));
    });
  });
}
