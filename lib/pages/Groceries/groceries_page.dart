import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/autofill_ingredient.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/Groceries/grocery_list.dart';
import 'package:flutter/material.dart';

class GroceriesPage extends StatefulWidget {
  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  Future<void>? _loadGroceriesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadGroceriesFuture = listeCourses.isLoaded();
    _loadGroceriesFuture = personals.isLoaded();
    _loadGroceriesFuture = ingredientsDict.isLoaded(); // Call load() only once
  }

  void toggleGroceryList(String ingredient, double? qtt) {
    setState(() {
      listeCourses.toggleIngredient(ingredient);
    });
  }

  void togglePersonalizedItem(String item) {
    setState(() {
      if (listeCourses.appearsInList(item)) {
        //print("Attention: grocery list already contains $item");
        listeCourses.forceRemoveIngredient(item);
      } else {
        listeCourses.addIngredient(item, null);
      }
    });
  }

  double calculateGroceriesPrice() {
    double total = 0.0;
    var groceries = listeCourses.getExtended();

    groceries.forEach((ingredient, quantity) {
      if (ingredientsDict.contains(ingredient)) {
        double pricePerUnit = ingredientsDict[ingredient]?['price'] ?? 0.0;
        double qtt = quantity;
        total += pricePerUnit * qtt;
      }
    });

    return total;
  }

  void clearAllGroceries() {
    setState(() {
      listeCourses.clearAll();
    });
  }

  void selectIngredient(String ingredient, double? qtt) {
    listeCourses.addIngredient(ingredient, qtt);
    setState(() {});
  }

  void addToOftenUsed(String item) {
    personals.coursesPersonnelles.addIngredient(item);
    listeCourses.addIngredient(item, null);
    setState(() {});
  }

  void removeFromOftenUsed(String item) {
    personals.coursesPersonnelles.removeIngredient(item);
    setState(() {});
  }

  Future<void> showAddToOftenUsedDialog(BuildContext context) {
    String customText = "";

    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 2, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ajouter aux items courants',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CloseButton(
                              style: ButtonStyle(
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.zero),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Ajouter un item\nnon comestible:',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiaryFixed,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            customText = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.edit,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryFixedVariant),
                            hintText: 'ex: Déodorant, Savon...',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryFixedVariant),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          if (customText.isNotEmpty) {
                            addToOftenUsed(customText);
                            Navigator.of(context).pop();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primaryFixedDim)),
                        child: Text(
                          'Ajouter',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showAddGroceryDialog(BuildContext context) {
    var selection = "";
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: 10,
                  height: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selection.isEmpty) ...[
                        AutofillIngredient(add: (String select) {
                          selection = select;
                          setState(() {});
                        })
                      ] else ...[
                        SizedBox(height: 20),
                        BlocTitle(
                            texte:
                                "${ingredientsDict.contains(selection) ? ingredientsDict[selection]!['icon'] : ""} $selection"),
                        SizedBox(height: 30),
                        TextButton(
                            onPressed: () {
                              addToOftenUsed(selection);
                              selection = "";
                              setState(() {});
                            },
                            child: Text(
                              "Ajouter",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(height: 10),
                      ],
                      SizedBox(height: 20),

                      // unfolding listss
                      Expanded(
                        child: ListView(
                          children: [
                            // EDIBLE
                            ExpansionTile(
                              title: Text("Comestible 🍎",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              children: [
                                for (String elmt
                                    in personals.coursesPersonnelles)
                                  if (ingredientsDict[elmt] != null &&
                                      ingredientsDict[elmt]?['icon'] != null &&
                                      ingredientsDict[elmt]?['icon'] != "") ...[
                                    ListTile(
                                      leading: Checkbox(
                                        value: listeCourses.appearsInList(elmt),
                                        onChanged: (bool? value) => {
                                          togglePersonalizedItem(elmt),
                                          setState(() {})
                                        },
                                      ),
                                      title: Text(elmt),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            size: 18),
                                        onPressed: () {
                                          removeFromOftenUsed(elmt);
                                          setState(() {});
                                        },
                                      ),
                                      onTap: () => {
                                        togglePersonalizedItem(elmt),
                                        setState(() {})
                                      },
                                    ),
                                  ]
                              ],
                            ),

                            // NON-EDIBLE
                            ExpansionTile(
                              tilePadding: EdgeInsets.fromLTRB(10, 5, 25, 5),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Non-comestible",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    icon: Icon(Icons.add_circle_outline,
                                        size: 20),
                                    onPressed: () async {
                                      await showAddToOftenUsedDialog(context);
                                      setState(() {});
                                    },
                                    tooltip: 'Add item',
                                  ),
                                ],
                              ),
                              children: [
                                for (String elmt
                                    in personals.coursesPersonnelles)
                                  if (ingredientsDict[elmt] == null ||
                                      ingredientsDict[elmt]?['icon'] == null ||
                                      ingredientsDict[elmt]?['icon'] == "") ...[
                                    ListTile(
                                      leading: Checkbox(
                                        value: listeCourses.appearsInList(elmt),
                                        onChanged: (bool? value) => {
                                          togglePersonalizedItem(elmt),
                                          setState(() {})
                                        },
                                      ),
                                      title: Text(elmt),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            size: 18),
                                        onPressed: () {
                                          removeFromOftenUsed(elmt);
                                          setState(() {});
                                        },
                                      ),
                                      onTap: () => {
                                        togglePersonalizedItem(elmt),
                                        setState(() {})
                                      },
                                    ),
                                  ]
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadGroceriesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return groceriesPageContent(context);
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading grocery page: ${snapshot.error}"));
          } else {
            return groceriesPageContent(context);
          }
        });
  }

  Scaffold groceriesPageContent(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return Scaffold(
      body: CustomScrollView(slivers: [
        // Fixed AppBar
        CustomSliverAppBar(title: "Liste de courses"),
        if (!listeCourses.isEmpty)
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: themeScheme.primaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total estimé:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        "${calculateGroceriesPrice().toStringAsFixed(2)} €",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 28),
                    color: themeScheme.error,
                    tooltip: 'Delete all groceries',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Voulez-vous vraiment vider toute la liste de courses ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  clearAllGroceries();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Vider',
                                    style: TextStyle(color: themeScheme.error)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        // Scrollable Content
        SliverList(
          delegate: GroceryList(
            onToggleGroceryList: toggleGroceryList,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeScheme.primary,
        foregroundColor: themeScheme.onPrimary,
        onPressed: () {
          showAddGroceryDialog(context);
        },
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
