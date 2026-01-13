import 'package:flutter/material.dart';

class BlocTitle extends StatelessWidget {
  const BlocTitle({
    super.key,
    required this.texte,
  });

  final String texte;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return Row(
      //"Your forbidden ingredients"
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            texte,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: isSmallScreen ? null : 30,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
