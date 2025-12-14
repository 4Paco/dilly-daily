import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/models/Step.dart' show Step;
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;

class StepElement extends StatelessWidget {
  const StepElement(
      {super.key,
      required this.ingredient,
      required this.initialStep,
      required this.onPressed,
      required this.onChanged});

  final String ingredient;
  final Step initialStep;
  final Function() onPressed;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading:
          IconButton(onPressed: onPressed, icon: Icon(Icons.delete_outline)),
      title: Row(
        children: [
          Text(ingredientsDict[ingredient]!["icon"]),
          SizedBox(width: 15),
          Text(ingredient),
        ],
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(
            color: themeScheme.surfaceContainer,
            border: Border.all(color: themeScheme.primary),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 70),
              child: TextFormField(
                initialValue: initialStep.formattedDuration(),
                onChanged: (value) => {onChanged(value)},
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                        gapPadding: 0),
                    suffix: Text(
                        ingredientsDict[ingredient]!["unit"] == ""
                            ? "units"
                            : ingredientsDict[ingredient]!["unit"],
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: themeScheme.primary,
                                ))),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
