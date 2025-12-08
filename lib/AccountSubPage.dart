import 'package:flutter/material.dart';

class AccountSubPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const AccountSubPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? ''),
      ),
      body: SafeArea(
        // The fragment page becomes the body
        child: item['page'],
      ),
    );
  }
}

