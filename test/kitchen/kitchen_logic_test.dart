import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Account/Kitchen/kitchen_logic.dart';
import 'package:dilly_daily/models/KitchenGear.dart';

void main() {
  final gear = [
    Gear(name: 'Oven', icon: Icons.kitchen, description: ''),
    Gear(name: 'Mixer', icon: Icons.kitchen, description: ''),
  ];

  test('initializes gear map correctly', () {
    final result = buildInitialGearMap(gear, ['Oven']);

    expect(result['Oven'], true);
    expect(result['Mixer'], false);
  });

  test('extracts selected gear from map', () {
    final map = {
      'Oven': true,
      'Mixer': false,
    };

    final selected = selectedGearFromMap(map);

    expect(selected, ['Oven']);
  });
}
