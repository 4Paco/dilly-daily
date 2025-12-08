import 'package:flutter/material.dart';

class CategoryTitleBloc extends StatelessWidget {
  const CategoryTitleBloc({
    super.key,
    required this.cat,
  });

  final String cat;

  @override
  Widget build(BuildContext context) {
    return Row(
      //"Your forbidden ingredients"
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: Text(
            cat,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
