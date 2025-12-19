import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/KitchenGear.dart';
import 'package:flutter/material.dart';

List<Gear> kitchenGear = [
  Gear(
    name: "Oven",
    icon: Icons.kitchen,
    description: "Modern electric oven for baking and roasting",
  ),
  Gear(
    name: "Mixer",
    icon: Icons.blender_rounded,
    description: "Kitchen mixer for smoothies and shakes",
  ),
  Gear(
    name: "Microwave",
    icon: Icons.microwave_rounded,
    description: "Microwave oven for heating food",
  ),
  Gear(
    name: "Fryer",
    icon: Icons.local_fire_department,
    description: "Deep fryer for fries and snacks",
  ),
];

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  _KitchenPageState createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final Map<String, bool> _hasGear = {};

  @override
  void initState() {
    super.initState();
    for (var gear in kitchenGear) {
      _hasGear[gear.name] = false;
    }
    for (var gearName in personals.kitchenGear) {
      _hasGear[gearName] = true;
    }
  }

  void _updateUserProfile() async {
    final selectedGear = _hasGear.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    personals.kitchenGear = selectedGear;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated and saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ❌ NO APP BAR
      // appBar: AppBar(... removed ...)

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: kitchenGear.length,
        itemBuilder: (context, index) {
          final gear = kitchenGear[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
              leading: Icon(
                gear.icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                gear.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                gear.description,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Checkbox(
                value: _hasGear[gear.name],
                activeColor: theme.colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _hasGear[gear.name] = value ?? false;
                  });
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _updateUserProfile,
        backgroundColor: Colors.white,
        child: const Icon(Icons.save),
      ),
    );
  }
}
