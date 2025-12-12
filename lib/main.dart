import 'package:dilly_daily/pages/Account/account_page.dart';
import 'package:dilly_daily/pages/Explore/explore_page.dart';
import 'package:dilly_daily/pages/Groceries/groceries_page.dart';
import 'package:dilly_daily/pages/MealPlan/mealplan_page.dart';
import 'package:dilly_daily/pages/Write/write_page.dart';
import 'package:flutter/material.dart';

import 'package:clarity_flutter/clarity_flutter.dart';

void main() {
  final config = ClarityConfig(
      projectId: "ukbsxmz277",
      logLevel: LogLevel
          .None // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
      );

  runApp(ClarityWidget(
    app: MyApp(),
    clarityConfig: config,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      initialRoute: "/home",
      routes: {
        "/home": (context) => MainPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 34, 214),
        ).copyWith(
          tertiaryContainer: const Color.fromARGB(
              255, 252, 227, 217), // Lighter color for tertiaryContainer
          //255, 255, 234, 226), // Lighter-lighter color for tertiaryContainer
          //255, 255, 219, 205), // original color for tertiaryContainer
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 1;

  final pages = [
    WritePage(),
    ExplorePage(),
    MealPlanPage(),
    GroceriesPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          //color: Theme.of(context).colorScheme.primaryContainer,
          child: pages[selectedIndex], // Display the selected page
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).colorScheme.primary,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: _onItemTapped,
              unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
              selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons
                      .auto_stories_rounded), //article_outlined //art_track_outlined
                  label: 'Write',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.manage_search),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_rounded),
                  label: 'Meal Plan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Groceries',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          ),
        ));
  }
}
// ...
