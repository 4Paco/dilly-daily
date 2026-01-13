import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.height,
    required this.themeScheme,
    required this.child,
  });

  final double height;
  final ColorScheme themeScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;

    return Column(
      children: [
        AppBar(
            toolbarHeight: height,
            backgroundColor: themeScheme.primary,
            foregroundColor: themeScheme.tertiaryFixed,
            centerTitle: height < 100,
            title: child),
        Divider(
          thickness: 5,
          color: themeScheme.tertiaryFixedDim,
          height: 5,
        ),
      ],
    );
  }
}
