import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ColorScheme themeScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      backgroundColor: themeScheme.primary,
      foregroundColor: themeScheme.tertiaryFixed,
      pinned: true,
      centerTitle: true,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Divider(
          thickness: 5,
          color: themeScheme.tertiaryFixedDim,
          height: 5,
        ),
      ),
    );
  }
}
