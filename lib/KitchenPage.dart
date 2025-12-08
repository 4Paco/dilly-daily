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



class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Kitchen Gear"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: kitchenGear.length,
          itemBuilder: (context, index) {
            final gear = kitchenGear[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: ListTile(
                leading: Icon(gear.icon, size: 32),
                title: Text(gear.name),
                subtitle: Text(gear.description),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        ),
      ),
    );
  }
}
