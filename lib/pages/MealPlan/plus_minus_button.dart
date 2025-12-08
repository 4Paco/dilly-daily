import 'package:flutter/material.dart';

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key,
    required this.function,
    required this.val,
    required this.icondata,
  });

  final void Function(int) function;
  final int val;
  final IconData icondata;

  @override
  Widget build(BuildContext context) {
    //var themeScheme = Theme.of(context).colorScheme;
    return Padding(
        padding: EdgeInsets.zero,
        child: IconButton.filled(
            padding: EdgeInsets.zero,
            //style: ButtonStyle(
            //    backgroundColor: WidgetStatePropertyAll(themeScheme.tertiary)),
            onPressed: () {
              function(val);
            },
            icon: Icon(
              icondata,
              size: 20,
            )));
  }
}
