import 'package:flutter/material.dart';

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key,
    required this.function,
    required this.val,
    required this.texte,
  });

  final void Function(int delta) function;
  final int val;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextButton(
        onPressed: () {
          function(val);
        },
        style: ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size.fromHeight(60)),
            backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.tertiaryFixedDim)),
        child: Text(texte,
            style: TextStyle(
                height: 1.05, fontSize: 40, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
