import 'package:dilly_daily/models/ui/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AccountSubPage extends StatelessWidget {
  const AccountSubPage({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: Column(
      children: [
        CustomAppBar(
          height: 60,
          themeScheme: themeScheme,
          child: Text(
            item["title"],
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        item["page"],
      ],
    ));
  }
}
