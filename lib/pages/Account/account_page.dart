import 'package:dilly_daily/models/ui/custom_app_bar.dart';
import 'package:dilly_daily/pages/Account/CookingProfile/cooking_profile_page.dart';
import 'package:dilly_daily/pages/Account/SpecialDiet/special_diet_page.dart';
import 'package:dilly_daily/pages/Account/account_sub_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final accountSubmenus = <Map<String, dynamic>>[
    {"title": 'Special diet', "icon": Icons.star, "page": SpecialDietPage()},
    {
      "title": "My cooking profile",
      "icon": Icons.restaurant_menu,
      "page": CookingProfilePage()
    },
    {
      "title": "My favorite meals",
      'icon': Icons.favorite_border,
      "page": Text("My favorite meals")
    },
    {
      "title": "My kitchen",
      'icon': Icons.blender_rounded,
      "page": Text("My kitchen")
    },
    {
      "title": "My friends",
      'icon': Icons.handshake_outlined,
      "page": Text("My friends")
    },
    {
      "title": "Notifications",
      'icon': Icons.notifications_outlined,
      "page": Text("Notifications")
    },
    {"title": "Help", 'icon': Icons.help_outline, "page": Text("Help")},
    {
      "title": "About",
      'icon': Icons.info_outline_rounded,
      "page": Text("About")
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomAppBar(
          height: 100.0,
          themeScheme: theme.colorScheme,
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: theme.colorScheme.onPrimary,
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Constrain the width
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Louise Baril",
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.tertiaryFixedDim,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Constrain the width
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "marie.sue@example.com",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (var item in accountSubmenus) ...[
                ListTile(
                  leading: Icon(item["icon"]),
                  title: Text(item["title"]),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.tertiary,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => AccountSubPage(item: item),
                        ));
                  },
                ),
                Divider(thickness: 1, color: theme.colorScheme.tertiary),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
