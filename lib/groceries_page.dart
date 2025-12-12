import 'package:dilly_daily/account_page.dart';
import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
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
              body: Stack(children: [
                CustomScrollView(slivers: [
                  // Fixed AppBar
                  SliverAppBar(
                      backgroundColor: themeScheme.primary,
                      foregroundColor: themeScheme.tertiaryFixed,
                      pinned: true,
                      centerTitle: true,
                      title: Text(
                        "Wanted \n-fresh or canned-",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      )),
                  PinnedHeaderSliver(
                    child: Divider(
                      thickness: 5,
                      color: themeScheme.tertiaryFixedDim,
                      height: 5,
                    ),
                  ),

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
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton.filled(
                          onPressed: () {
                            showAddGroceryDialog(context);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 40,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                      )
                    ],
                  )
                ]),
              ]),
            );
          }
        });
  }
}

class GroceryList extends SliverChildBuilderDelegate {
  GroceryList({
    required void Function(String, double) onToggleGroceryList,
  }) : super((BuildContext context, int index) {
          var ongoingList = listeCourses.getExtended();
          var items = <Widget>[];
          var others = <Widget>[];
          if (listeCourses.isEmpty) {
            items.add(BlocTitle(texte: "No ingredients to shop yet"));
            return index < items.length ? items[index] : null;
          }

          // Process additional elements that are no ingredient
          List<String> shopList = List.from(ongoingList.keys);
          for (String ingredient in shopList) {
            if (!ingredientsDict.contains(ingredient)) {
              others.add(IngredientTile(
                  ingredient: ingredient,
                  qtt: listeCourses[ingredient] ?? 0.0,
                  onToggleGroceryList: onToggleGroceryList));
              ongoingList.remove(ingredient);
            }
          }
          //print(listeCourses.extendedGroceriesDict);
          if (others.isNotEmpty) {
            others.insert(0, CategoryTitleBloc(cat: "Other"));
          }

          //Process usual elements
          for (String cat in ingredientsDict.ingredientCategories) {
            int catNb = 0;
            List<String> shopList = List.from(ongoingList
                .keys); //to avoid problems when ongoingList get ingredients removed
            for (String ingredient in shopList) {
              if (ingredientsDict[ingredient]!["category"] == cat) {
                catNb += 1;
                if (catNb == 1) items.add(CategoryTitleBloc(cat: cat));
                items.add(IngredientTile(
                    ingredient: ingredient,
                    qtt: listeCourses[ingredient] ?? 0.0,
                    onToggleGroceryList: onToggleGroceryList));
                ongoingList.remove(ingredient);
              }
            }
          }
          items = items + others;

          return index < items.length ? items[index] : null;
        });
}

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.qtt,
    required this.onToggleGroceryList,
  });

  final String ingredient;
  final double qtt;
  final void Function(String, double) onToggleGroceryList;

  @override
  Widget build(BuildContext context) {
    bool isChecked = listeCourses.isIngredientChecked(ingredient);
    dynamic displayedQtt = qtt;
    String unit;

    if (ingredientsDict.contains(ingredient)) {
      unit = ingredientsDict[ingredient]!["unit"] ?? "";
    } else {
      unit = "";
    }
    String texte = "";

    if (unit.isEmpty) {
      // inverse ingredient name and qtt
      if (displayedQtt.round() == displayedQtt) {
        displayedQtt = displayedQtt.round();
      }

      if (displayedQtt > 0) {
        texte = "${displayedQtt.toString()} ";
      }
      texte += ingredient;
      if (displayedQtt > 1) {
        //add an "s" to the ingredient when there's several
        texte += "s";
      }
    } else {
      texte = ingredient;

      if (!unit.endsWith("g") && !unit.endsWith("L")) {
        unit = " $unit"; //space for readability
        if (displayedQtt > 1) {
          if (unit.endsWith("h")) {
            //pinch
            unit = "${unit}es";
          } else {
            unit = "${unit}s"; //spoon
          }
        }
      }

      if (displayedQtt > 1000) {
        if (unit.startsWith("m")) {
          unit = unit.substring(1);
          displayedQtt = displayedQtt / 1000;
        } else if ((unit == "g") || (unit == "L")) {
          unit = "k$unit";
          displayedQtt = displayedQtt / 1000;
        }
      }

      if (displayedQtt.round() == displayedQtt) {
        displayedQtt = displayedQtt.round();
      }
      if (displayedQtt > 0) {
        texte += " : ${displayedQtt.toString()}$unit";
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (value) {
              isChecked = !isChecked;
              onToggleGroceryList(ingredient, qtt);
            }),
        Text(
          texte,
          style: isChecked
              ? TextStyle(decoration: TextDecoration.lineThrough)
              : TextStyle(),
        ),
      ],
    );
  }
}

class CategoryTitleBloc extends StatelessWidget {
  const CategoryTitleBloc({
    super.key,
    required this.cat,
  });

  final String cat;

  @override
  Widget build(BuildContext context) {
    return Row(
      //"Your forbidden ingredients"
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: Text(
            cat,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
