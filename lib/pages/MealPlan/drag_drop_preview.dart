import 'package:flutter/material.dart';

class DragDropPreview extends StatelessWidget {
  const DragDropPreview({
    super.key,
    required this.texte,
    required this.img,
  });
  final String texte;
  final String img;

  @override
  Widget build(BuildContext context) {
    var imgDisplayed = img;
    if (img.isEmpty) {
      imgDisplayed = "assets/image/meals/placeholder.jpg";
    }
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        width: 100,
        height: 100,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width:
                    300, //has to overflow actual size to work without error (??)
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    imgDisplayed, // Ensures the image covers the button
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
