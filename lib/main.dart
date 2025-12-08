import 'package:dilly_daily/pages/Explore/explore_page.dart';
import 'package:dilly_daily/pages/Account/account_page.dart';
import 'package:dilly_daily/pages/Groceries/groceries_page.dart';
import 'package:dilly_daily/pages/MealPlan/mealplan_page.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
    GeneratorPage(),
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
                  icon: Icon(Icons.home),
                  label: 'Home',
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

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pair = WordPair("a", "b");

    IconData icon;
    if (1 == 2) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  //appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  //appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LilCard extends StatelessWidget {
  const LilCard({
    super.key,
    required this.fav,
  });

  final WordPair fav;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon = Icons.favorite;

    return Card(
      color: theme.colorScheme.secondary,
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.onSecondary,
        ),
        title: Text(fav.asPascalCase),
        textColor: theme.colorScheme.onSecondary,
        trailing:
            Icon(Icons.delete_forever, color: theme.colorScheme.onSecondary),
        onTap: () {},
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
