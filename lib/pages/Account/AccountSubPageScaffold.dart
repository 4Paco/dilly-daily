import 'package:flutter/material.dart';

class AccountSubPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool centerTitle;

  const AccountSubPageScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),

        centerTitle: centerTitle,

        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,       // title text color
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: actions,
      ),

      body: body,
    );
  }
}
