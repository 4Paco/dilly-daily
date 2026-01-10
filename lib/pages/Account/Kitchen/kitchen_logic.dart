import '../../../models/KitchenGear.dart';

Map<String, bool> buildInitialGearMap(
    List<Gear> allGear,
    List<String> selectedGear,
    ) {
  final map = <String, bool>{};
  for (final gear in allGear) {
    map[gear.name] = selectedGear.contains(gear.name);
  }
  return map;
}

List<String> selectedGearFromMap(Map<String, bool> map) {
  return map.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();
}
