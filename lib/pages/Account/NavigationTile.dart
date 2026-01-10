import 'package:flutter/material.dart';
import 'AccountSubPageScaffold.dart';

class NavigationTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Widget leading;
  final Widget? trailing;

  const NavigationTile({
    Key? key,
    required this.item,
    required this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = item['title'] as String? ?? 'Untitled';

    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: () {
        final Widget pageBody = item['page'] as Widget;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSubPageScaffold(
              title: item['title'],
              body: pageBody,
            ),
          ),
        );
      },
    );
  }
}

