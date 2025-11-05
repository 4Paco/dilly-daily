import 'package:dilly_daily/account_page.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:flutter/material.dart';

List<int> generateSuggestions() {
  return recipesDict.toList();
}

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Future<void>? _loadGroceriesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadGroceriesFuture = listeCourses.isLoaded();
    _loadGroceriesFuture = recipesDict.isLoaded(); // Call load() only once
  }

  void toggleFavorite(int recipeKey) {
    setState(() {
      if (favoriteRecipes.contains(recipeKey)) {
        favoriteRecipes.remove(recipeKey);
      } else {
        favoriteRecipes.add(recipeKey);
      }
    });
  }

  void toggleMealPlan(int recipeKey) {
    setState(() {
      if (mealPlanList.contains(recipeKey)) {
        mealPlanList.remove(recipeKey);
      } else {
        mealPlanList.add(recipeKey);
      }
      print(mealPlanList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
        future: _loadGroceriesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading allergies: ${snapshot.error}"));
          } else {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  // Fixed AppBar
                  SliverAppBar(
                      backgroundColor: themeScheme.primary,
                      foregroundColor: themeScheme.tertiaryFixed,
                      pinned: true,
                      centerTitle: true,
                      title: Text(
                        "Explore",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )),
                  PinnedHeaderSliver(
                    child: Divider(
                      thickness: 5,
                      color: themeScheme.tertiaryFixedDim,
                      height: 5,
                    ),
                  ),

                  PinnedHeaderSliver(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: themeScheme.tertiaryFixed,
                        borderRadius:
                            BorderRadius.circular(25), // Rounded corners
                      ),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return const Iterable<String>.empty();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              border:
                                  InputBorder.none, // Removes the bottom line
                              icon: Icon(Icons.search,
                                  color: themeScheme.onPrimaryFixedVariant),
                              hintText: 'Search ideas...',
                              hintStyle: TextStyle(
                                  color: themeScheme
                                      .onPrimaryFixedVariant), // Placeholder style
                            ), // Text style
                          );
                        },
                      ),
                    ),
                  ),

                  // Scrollable Content
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        BlocTitle(texte: "Favoris"),
                        FavoriteCarousel(
                          onToggleMealPlan: toggleMealPlan,
                          onToggleFavorite: toggleFavorite,
                        ),
                        BlocTitle(texte: "Suggestions"),
                        GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable GridView scrolling
                          crossAxisCount: 2,
                          childAspectRatio: 1, // Adjust to control item size
                          children: [
                            for (var recipe in generateSuggestions()) ...[
                              RecipePreview(
                                recipe: recipe,
                                texte: recipesDict[recipe]!["name"],
                                img: recipesDict[recipe]!["image"],
                                onToggleMealPlan: toggleMealPlan,
                                onToggleFavorite: toggleFavorite,
                              )
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

class FavoriteCarousel extends StatelessWidget {
  const FavoriteCarousel({
    super.key,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
  });
  final void Function(int) onToggleMealPlan;
  final void Function(int) onToggleFavorite; // Callback function type

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          for (int recipeKey in favoriteRecipes) ...[
            SizedBox(
              width: 150,
              child: RecipePreview(
                  recipe: recipeKey,
                  texte: recipesDict[recipeKey]!["name"],
                  img: recipesDict[recipeKey]!["image"],
                  onToggleMealPlan: onToggleMealPlan,
                  onToggleFavorite: onToggleFavorite,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 10)),
            )
          ]
        ],
      ),
    );
  }
}

class RecipePreview extends StatelessWidget {
  const RecipePreview({
    super.key,
    required this.recipe,
    required this.texte,
    required this.img,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    this.padding = const EdgeInsets.all(15.0),
  });
  final int recipe;
  final String texte;
  final String img;

  final void Function(int) onToggleMealPlan;
  final void Function(int) onToggleFavorite; // Callback function type
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    var imgDisplayed = img;
    if (img.isEmpty) {
      imgDisplayed = "assets/image/meals/placeholder.jpg";
    }
    return Padding(
      padding: padding,
      child: FilledButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return RecipeDialogBox(
                    recipe: recipe,
                    onToggleMealPlan: (recipeKey) {
                      onToggleMealPlan(recipeKey);
                      setState(() {});
                    },
                    onToggleFavorite: (recipeKey) {
                      onToggleFavorite(recipeKey);
                      setState(() {}); // Rebuild the dialog to update the icon
                    },
                  );
                },
              );
            },
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 300, //overflowing, but no error so it works
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    imgDisplayed, // Ensures the image covers the button
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 40),
              child: Text(
                texte,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDialogBox extends StatelessWidget {
  const RecipeDialogBox({
    super.key,
    required this.recipe,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
  });

  final int recipe;
  final void Function(int) onToggleMealPlan;
  final void Function(int) onToggleFavorite;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 150;
  final double verticalOffset = 50;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    IconData icon;
    if (favoriteRecipes.contains(recipe)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Padding(
      padding: EdgeInsets.only(
          top: verticalPadding - verticalOffset,
          bottom: verticalPadding + verticalOffset,
          right: horizontalPadding,
          left: horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: themeScheme.tertiaryContainer,
            border:
                BoxBorder.all(width: 2, color: Color.fromARGB(100, 0, 0, 0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloseButton(),
                IconButton(
                    onPressed: () {
                      onToggleFavorite(recipe);
                    },
                    icon: Icon(
                      icon,
                      size: 30,
                    ))
              ],
            ),
            Text(
              recipesDict[recipe]!["name"] + "\n[Recipe preview]",
              textAlign: TextAlign.center,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextButton(
                      style: ButtonStyle(
                          shadowColor:
                              WidgetStateProperty.all(themeScheme.shadow),
                          elevation: WidgetStateProperty.all(2),
                          foregroundColor:
                              WidgetStateProperty.all(themeScheme.onPrimary),
                          backgroundColor: WidgetStateProperty.all(
                              mealPlanList.contains(recipe)
                                  ? themeScheme.tertiary
                                  : themeScheme.primary)),
                      onPressed: () {
                        onToggleMealPlan(recipe);
                      },
                      child: mealPlanList.contains(recipe)
                          ? Text("Added to Meal Plan")
                          : Text("Add to Meal Plan")),
                )),
                if (mealPlanList.contains(recipe)) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          color: themeScheme.tertiaryFixedDim,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.check,
                              color: themeScheme.secondaryFixed),
                        )),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
