import 'package:flutter/material.dart';

class CuratedBloc extends StatelessWidget {
  const CuratedBloc({
    super.key,
    required this.texte,
    required this.onAddDiet,
  });

  final String texte;
  final Function(String) onAddDiet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {
          String search = "";
          if (texte == "Végan") {
            search = "vegan";
          } else if (texte == "Végétarien") {
            search = "vegetarian";
          } else if (texte == "Hallal") {
            search = "hallal";
          } else {
            search = "glutenfree";
          }
          onAddDiet(search);
        },
        child: Text(texte.toUpperCase(),
            style:
                TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed)),
      ),
    );
  }
}
