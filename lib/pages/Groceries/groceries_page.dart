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
                  CustomSliverAppBar(title: "Wanted \n-fresh or canned-"),

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
