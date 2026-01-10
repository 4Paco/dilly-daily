import 'package:dilly_daily/models/ui/custom_app_bar.dart';
import 'package:dilly_daily/pages/Account/AccountSubPageScaffold.dart'
    show AccountSubPageScaffold;
import 'package:dilly_daily/pages/Account/CookingProfile/cooking_profile_page.dart';
import 'package:dilly_daily/pages/Account/Kitchen/KitchenPage.dart';
import 'package:dilly_daily/pages/Account/SpecialDiet/special_diet_page.dart'
    show SpecialDietPage;
import 'package:flutter/material.dart';
import 'package:dilly_daily/data/personalisation.dart';

class AccountSubmenu {
  final String title;
  final IconData icon;
  final Widget page;

  const AccountSubmenu({
    required this.title,
    required this.icon,
    required this.page
  });
}


class BlocTitle extends StatelessWidget {
  const BlocTitle({
    super.key,
    required this.texte,
  });

  final String texte;

  @override
  Widget build(BuildContext context) {
    return Row(
      //"Your forbidden ingredients"
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            texte,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class AccountPage extends StatelessWidget {
  final List<AccountSubmenu> accountSubmenus = const [
  AccountSubmenu(
  title: 'Special diet',
  icon: Icons.star,
  page: SpecialDietPage(),
  ),
  AccountSubmenu(
  title: 'My cooking profile',
  icon: Icons.restaurant_menu,
  page: CookingProfilePage(),
  ),
  AccountSubmenu(
  title: 'My favorite meals',
  icon: Icons.favorite_border,
  page: Text('My favorite meals'),
  ),
  AccountSubmenu(
  title: 'My kitchen',
  icon: Icons.blender_rounded,
  page: KitchenPage(),
  ),
  AccountSubmenu(
  title: 'My friends',
  icon: Icons.handshake_outlined,
  page: Text('My friends'),
  ),
  AccountSubmenu(
  title: 'Notifications',
  icon: Icons.notifications_outlined,
  page: Text('Notifications'),
  ),
  AccountSubmenu(
  title: 'Help',
  icon: Icons.help_outline,
  page: Text('Help'),
  ),
  AccountSubmenu(
  title: 'About',
  icon: Icons.info_outline_rounded,
  page: Text('About'),
  ),
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
              //Text("We improve our product by using Microsoft Clarity to see how you use our app. By using our app, you agree that we and Microsoft can collect and use this data." +
              //    "We use Microsoft Clarity to capture how you use and interact with our app through behavioral metrics, heatmaps, and session replay to improve our app." +
              //    "App usage data is captured using first-party cookies and other tracking technologies for site optimization. For more information about how Microsoft collects and uses your data, visit the Microsoft Privacy Statement."),
              for (final item in accountSubmenus) ...[
                ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.tertiary,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountSubPageScaffold(
                          title: item.title,
                          body: item.page
                        ),
                      ),
                    );
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
