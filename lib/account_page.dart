import 'dart:math';

import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:gradient_slider/gradient_slider.dart';

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
        AccountAppBar(
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

class AccountAppBar extends StatelessWidget {
  const AccountAppBar({
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
        AccountAppBar(
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

class SpecialDietPage extends StatefulWidget {
  const SpecialDietPage({
    super.key,
  });

  @override
  State<SpecialDietPage> createState() => _SpecialDietPageState();
}

class _SpecialDietPageState extends State<SpecialDietPage> {
  Future<void>? _loadAllergiesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadAllergiesFuture = allergiesList.isLoaded(); // Call load() only once
  }

  void setIntensity(String ingredient, bool value) {
    allergiesList.setIntensity(ingredient, value);
    setState(() {});
  }

  void deleteIngredient(String ingredient) {
    allergiesList.removeIngredient(ingredient);
    setState(() {});
  }

  void addIngredient(String ingredient) {
    allergiesList.addIngredient(ingredient);
    setState(() {});
  }

  void addDiet(String diet) {
    setState(() {
      for (var ingredient in ingredientsDict) {
        if (ingredientsDict.isNotDiet(diet, ingredient)) {
          addIngredient(ingredient);
        }
      }
    });
  }

  var valueKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadAllergiesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading allergies: ${snapshot.error}"));
          } else {
            // Show the actual content once loading is complete

            return Expanded(
              child: Column(children: [
                AutofillIngredient(add: (String selection) {
                  addIngredient(selection);
                  setState(() {});
                }),
                if (allergiesList.isNotEmpty) ...[
                  Column(
                    //Forbidden ingredients bloc
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocTitle(texte: "Your forbidden ingredients"),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              for (var ingredient in allergiesList)
                                AllergyElement(
                                  ingredient: ingredient,
                                  isToggled: allergiesList[ingredient]!,
                                  onToggle: (value) =>
                                      setIntensity(ingredient, value),
                                  onPressed: () => deleteIngredient(ingredient),
                                )
                            ]),
                      ),
                    ],
                  ),
                ],
                Expanded(
                  child: Column(
                    //Curated List bloc
                    children: [
                      BlocTitle(texte: "Curated Lists"),
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 1, // Adjust to control item size
                          children: [
                            CuratedBloc(
                                texte: "vegetarian", onAddDiet: addDiet),
                            CuratedBloc(texte: "hallal", onAddDiet: addDiet),
                            CuratedBloc(
                                texte: "glutenfree", onAddDiet: addDiet),
                            CuratedBloc(texte: "vegan", onAddDiet: addDiet),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }
        });
  }
}

// ignore: must_be_immutable
class AutofillIngredient extends StatelessWidget {
  AutofillIngredient({
    super.key,
    required this.add,
    //required this.valueKey,
  });
  final Function(String) add;
  var valueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var themeScheme = Theme.of(context).colorScheme;
    return Container(
      //Ingredients search bar
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeScheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(25), // Rounded corners
      ),
      child: Autocomplete<String>(
        key: valueKey,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return ingredientsDict.where((option) {
            return option
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase());
          }).cast<String>();
        },
        onSelected: (String selection) {
          valueKey =
              UniqueKey(); //reset the widget to make the typed-in content disappear
          add(selection);
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: InputBorder.none, // Removes the bottom line
              icon:
                  Icon(Icons.search, color: themeScheme.onPrimaryFixedVariant),
              hintText: 'Search ingredients...',
              hintStyle: TextStyle(
                  color:
                      themeScheme.onPrimaryFixedVariant), // Placeholder style
            ), // Text style
          );
        },
      ),
    );
  }
}

class AllergyElement extends StatelessWidget {
  const AllergyElement(
      {super.key,
      required this.ingredient,
      required this.isToggled,
      required this.onToggle,
      required this.onPressed});

  final String ingredient;
  final bool isToggled;
  final ValueChanged<bool> onToggle;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          IconButton(onPressed: onPressed, icon: Icon(Icons.delete_outline)),
      title: Row(
        children: [
          Text(ingredientsDict[ingredient]!["icon"]),
          SizedBox(width: 15),
          Text(ingredient),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
        children: [
          Text(EmojiParser().get("face_vomiting").code,
              style: TextStyle(fontSize: 20)), // First icon
          SizedBox(width: 5), // Spacing between icon and switch
          Switch(
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.orange,
            thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              return Colors.white;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              return const Color.fromARGB(
                  20, 0, 0, 0); // Consistent outline color.
            }),
            value: isToggled,
            onChanged: onToggle,
          ),
          SizedBox(width: 5),
          Text(EmojiParser().get("skull").code, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class CuratedBloc extends StatelessWidget {
  const CuratedBloc({
    super.key,
    required this.texte,
    required this.onAddDiet,
  });

  final String texte;
  final Function(String) onAddDiet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {
          onAddDiet(texte);
        },
        child: Text(texte.toUpperCase(),
            style:
                TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed)),
      ),
    );
  }
}

class CookingProfilePage extends StatefulWidget {
  const CookingProfilePage({
    super.key,
  });

  @override
  State<CookingProfilePage> createState() => _CookingProfilePageState();
}

class _CookingProfilePageState extends State<CookingProfilePage> {
  void setDefaultMealsNumber(int delta) {
    setState(() {
      defaultPersonNumber = max(1, defaultPersonNumber + delta);
    });
  }

  void updatePatience(double newVal) {
    setState(() {
      patience = max(0.1, min(0.9, (newVal * 10).roundToDouble() / 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    final nbStyle = Theme.of(context).textTheme.headlineSmall;
    final sliderLabelStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        BlocTitle(texte: "Number of portions per meal"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          PlusMinusButton(function: setDefaultMealsNumber, val: -1, texte: "-"),
          Text(
            defaultPersonNumber.toString(),
            style: nbStyle,
          ),
          SizedBox(width: 7),
          Icon(
            Icons.restaurant,
            size: 30,
            //color: themeScheme.primary,
          ),
          PlusMinusButton(function: setDefaultMealsNumber, val: 1, texte: "+")
        ]),
        BlocTitle(texte: "Patience for cooking"),
        //Image.asset("assets/image/slider_thumb_cute.png")
        Stack(children: [
          GradientSlider(
            thumbAsset: 'assets/image/slider_thumb_cute_primary.png',
            thumbHeight: 30,
            thumbWidth: 30,
            trackHeight: 20,
            activeTrackGradient:
                const LinearGradient(colors: [Colors.blue, Colors.pink]),
            inactiveTrackGradient:
                LinearGradient(colors: [Colors.blue, Colors.pink]),
            slider: Slider(
                value: patience,
                onChanged: (value) {
                  updatePatience(value);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 54, top: 20),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: patience == 0.1 ? 7 : 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 54, top: 20),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: patience == 0.9 ? 7 : 25,
                ),
              ),
            ],
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Might not\neat",
                style: sliderLabelStyle,
              ),
              Text(
                "Love elaborate\nmeals",
                textAlign: TextAlign.end,
                style: sliderLabelStyle,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key,
    required this.function,
    required this.val,
    required this.texte,
  });

  final void Function(int delta) function;
  final int val;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextButton(
        onPressed: () {
          function(val);
        },
        style: ButtonStyle(
            maximumSize: WidgetStatePropertyAll(Size.fromHeight(60)),
            backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.tertiaryFixedDim)),
        child: Text(texte,
            style: TextStyle(
                height: 1.05, fontSize: 40, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
