import 'package:dilly_daily/account_page.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:flutter/material.dart';

List<String> generateSuggestions() {
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

  void toggleFavorite(String recipeKey) {
    setState(() {
      if (favoriteRecipes.contains(recipeKey)) {
        favoriteRecipes.remove(recipeKey);
      } else {
        favoriteRecipes.add(recipeKey);
      }
    });
  }

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        print(
            "mealPlan contains recipeKey $recipeKey : removing recipe from mealPlan");
        mealPlanRecipes.removeRecipe(recipeKey);
      } else {
        print(
            "mealPlan does not contain recipeKey $recipeKey : adding recipe to mealPlan");
        mealPlanRecipes.addRecipe(recipesDict.getRecipe(recipeKey),
            recipeKey: recipeKey);
      }
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
                child: Text( "Error: ${snapshot.error}\n${snapshot.stackTrace}",));
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
                        if (favoriteRecipes.isNotEmpty) ...[
                          BlocTitle(texte: "Favoris"),
                          FavoriteCarousel(
                            onToggleMealPlan: toggleMealPlan,
                            onToggleFavorite: toggleFavorite,
                          )
                        ],
                        BlocTitle(texte: "Suggestions"),
                        GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable GridView scrolling
                          crossAxisCount: 2,
                          childAspectRatio: 1, // Adjust to control item size
                          children: [
                            for (String recipeKey in generateSuggestions()) ...[
                              RecipePreview(
                                recipeKey: recipeKey,
                                texte: recipesDict[recipeKey]!.name,
                                img: recipesDict[recipeKey]!.image,
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
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite; // Callback function type

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          for (String recipeKey in favoriteRecipes) ...[
            SizedBox(
              width: 150,
              child: RecipePreview(
                  recipeKey: recipeKey,
                  texte: recipesDict[recipeKey]!.name,
                  img: recipesDict[recipeKey]!.image,
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
    required this.recipeKey,
    required this.texte,
    required this.img,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    this.padding = const EdgeInsets.all(15.0),
  });
  final String recipeKey;
  final String texte;
  final String img;

  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite; // Callback function type
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
                    recipeKey: recipeKey,
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
    required this.recipeKey,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
  });

  final String recipeKey;
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 150;
  final double verticalOffset = 50;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    final recipe = recipesDict[recipeKey]!; // Get Recipe object
    final isFavorite = favoriteRecipes.contains(recipeKey);
    final isInMealPlan = mealPlanRecipes.containsKey(recipeKey);

    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding - verticalOffset,
        bottom: verticalPadding + verticalOffset,
        right: horizontalPadding,
        left: horizontalPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: themeScheme.tertiaryContainer,
          border: Border.all(width: 2, color: Color.fromARGB(100, 0, 0, 0)),
        ),
        child: Column(
  children: [
    // Top row: Close button + Favorite
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CloseButton(),
        IconButton(
          onPressed: () => onToggleFavorite(recipeKey),
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, size: 30),
        )
      ],
    ),

    // Recipe title
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            recipe.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          /// NEW LINE FOR RECIPE DURATION
          if (recipe.duration().inMinutes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                recipe.duration().inMinutes < 60
                    ? "${recipe.duration().inMinutes} min"
                    : "${recipe.duration().inHours}h${recipe.duration().inMinutes % 60 == 0 ? '' : '${recipe.duration().inMinutes % 60}'}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black, // ✔ duration text black
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    ),

    // Steps list
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.separated(
          itemCount: recipe.steps.length,
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final step = recipe.steps[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}. ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.description),

                      /// NEW → Step type added under description
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          step.type.name[0].toUpperCase() + step.type.name.substring(1),
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Duration shown right aligned
                if (step.duration != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      step.formattedDuration(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black, // ✔ specifically BLACK
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),

          ],
        ),
      
      
      
      ),
    );
  }
}
