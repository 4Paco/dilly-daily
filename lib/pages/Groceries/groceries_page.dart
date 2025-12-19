import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/autofill_ingredient.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/Groceries/grocery_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    _loadGroceriesFuture = coursesPersonnelles.isLoaded();
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

  void selectIngredient(String ingredient, double? qtt) {
    listeCourses.addIngredient(ingredient, qtt);
    setState(() {});
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
                child: Container(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  width: 10,
                  height: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selection.isEmpty) ...[
                        AutofillIngredient(add: (String select) {
                          //selectIngredient(select, 3);
                          selection = select;
                          setState(() {});
                        })
                      ] else ...[
                        BlocTitle(
                            texte:
                                "${ingredientsDict.contains(selection) ? ingredientsDict[selection]!['icon'] : ""} $selection"),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: TextEditingController(text: "1"),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 40,
                                child: Text(
                                    " ${ingredientsDict[selection]!["unit"]}"))
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              selectIngredient(selection, 2);
                              selection = "";
                              setState(() {});
                            },
                            child: Text("okay")),
                      ],
                      SizedBox(
                        height: 20,
                      ),
                      BlocTitle(texte: "Often used :"),
                      Expanded(
                          child: ListView(
                        children: [
                          for (String elmt in coursesPersonnelles) ...[
                            ListTile(
                              leading: Checkbox(
                                value: listeCourses.appearsInList(elmt),
                                onChanged: (bool? value) => {
                                  togglePersonalizedItem(elmt),
                                  setState(() {})
                                },
                              ),
                              enabled: true,
                              title: Text(elmt),
                              onTap: () => {
                                togglePersonalizedItem(elmt),
                                setState(() {})
                              },
                            ),
                          ]
                        ],
                      ))
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
                child: Text("Error loading allergies: ${snapshot.error}"));
          } else {
            return groceriesPageContent(context);
          }
        });
  }

  Scaffold groceriesPageContent(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(slivers: [
        // Fixed AppBar
        CustomSliverAppBar(title: "Wanted \n-fresh or canned-"),
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
                  Text(
                    "Estimated total:",
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
