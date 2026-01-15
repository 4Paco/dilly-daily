import 'package:dilly_daily/data/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class AllergyElement extends StatelessWidget {
  const AllergyElement(
      {super.key,
      required this.ingredient,
      required this.isToggled,
      required this.onToggle,
      required this.onPressed});

  final String ingredient;
  final bool isToggled;
  final ValueChanged<bool> onToggle;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          IconButton(onPressed: onPressed, icon: Icon(Icons.delete_outline)),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(ingredientsDict[ingredient]!["icon"]),
            SizedBox(width: 15),
            Text(ingredient),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
        children: [
          Text(EmojiParser().get("face_vomiting").code,
              style: TextStyle(fontSize: 20)), // First icon
          SizedBox(width: 5), // Spacing between icon and switch
          Switch(
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.orange,
            thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              return Colors.white;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              return const Color.fromARGB(
                  20, 0, 0, 0); // Consistent outline color.
            }),
            value: isToggled,
            onChanged: onToggle,
          ),
          SizedBox(width: 5),
          Text(EmojiParser().get("skull").code, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
