import 'package:flutter/material.dart';

class EmptyPreview extends StatelessWidget {
  const EmptyPreview({
    super.key,
    this.padding = const EdgeInsets.all(4.0),
  });
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FilledButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.all(50)),
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(""),
      ),
    );
  }
}
