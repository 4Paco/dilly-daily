import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Account/CookingProfile/cooking_profile_logic.dart';

void main() {
  group('Clamp portion count', () {
    test('never goes below 1', () {
      expect(clampPortionCount(1, -1), 1);
      expect(clampPortionCount(5, -10), 1);
    });

    test('increments correctly', () {
      expect(clampPortionCount(2, 1), 3);
      expect(clampPortionCount(0, 5), 5); // still clamps to at least 1
    });
  });

  group('Normalize patience', () {
    test('rounds to nearest 0.1', () {
      expect(normalizePatience(0.56), 0.6);
      expect(normalizePatience(0.14), 0.1);
      expect(normalizePatience(0.87), 0.9);
    });

    test('clamps between 0.1 and 0.9', () {
      expect(normalizePatience(0.0), 0.1);
      expect(normalizePatience(1.0), 0.9);
    });
  });
}
