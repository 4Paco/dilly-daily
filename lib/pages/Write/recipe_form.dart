import 'dart:io' show Directory, File;
import 'dart:ui' show lerpDouble;

import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/models/Step.dart' show Step, StepType;
import 'package:dilly_daily/models/recipes_dico.dart';
import 'package:dilly_daily/models/ui/category_title_bloc.dart';
import 'package:dilly_daily/pages/Write/Modules/ingredient_element.dart';
import 'package:dilly_daily/pages/Write/Modules/input_ingredient.dart'
    show InputIngredient;
import 'package:dilly_daily/pages/Write/Modules/photo_cropper.dart';
import 'package:dilly_daily/pages/Write/Modules/step_editor.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class RecipeForm extends StatefulWidget {
  const RecipeForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final EditSubPage widget;

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController linkController;

  late bool isDishTypeExpanded;
  late bool isUtensilsExpanded;
  late bool isIngredientExpanded;
  late bool isStepExpanded; // Track whether the section is expanded

  bool _isAddingIngredient = false;
  bool _isAddingStep = false; // Nouvel état pour contrôler l'affichage
  int? _editingStepIndex;

  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  String? _savedImagePath; // Chemin permanent de l'image sauvegardée

  late Map<String, double> _tempIngredients;
  late List<String> _tempDishTypes;
  late List<String> _tempUtensils;
  late List<Step> _tempSteps;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.widget.recette.name);
    descriptionController =
        TextEditingController(text: widget.widget.recette.summary);
    linkController =
        TextEditingController(text: widget.widget.recette.recipeLink);
    //
    // Créer des copies des données complexes
    _tempIngredients =
        Map<String, double>.from(widget.widget.recette.ingredients);
    _tempDishTypes = List<String>.from(widget.widget.recette.dishTypes);
    _tempUtensils = List<String>.from(widget.widget.recette.necessaryGear);
    _tempSteps = widget.widget.recette.steps
        .map((step) => Step(
              description: step.description,
              duration: step.duration,
              type: step.type,
            ))
        .toList();
    isDishTypeExpanded = _tempDishTypes.isEmpty;
    isUtensilsExpanded = _tempUtensils.isEmpty;
    isIngredientExpanded = _tempIngredients.isEmpty;
    isStepExpanded = _tempSteps.isEmpty;
    //
    // Charger l'image existante si en mode édition
    if (widget.widget.recette.image.isNotEmpty) {
      _savedImagePath = widget.widget.recette.image;
      _croppedFile = CroppedFile(widget.widget.recette.image);
      _pickedFile = XFile(widget.widget.recette.image);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  //Recipe({
  //    ok this.name = "",
  //    String? id,
  //    ok this.summary = "",
  //    this.steps = const [],
  //    ok this.ingredients = const {},
  //    this.personalized = "Nope", //maybe mettre le "globalDict" id ici
  //    ok this.recipeLink = "",
  //    ok this.dishTypes = const ["Meal"],
  //    this.servings = 1,
  //    ok this.image = ""})
  //    : id = id ?? Uuid().v4();
  Future<String> _saveImagePermanently(String sourcePath) async {
    // Obtenir le répertoire de documents de l'application
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // Créer un sous-dossier pour les images de recettes
    final Directory recipeImagesDir =
        Directory('${appDocDir.path}/recipe_images');
    if (!await recipeImagesDir.exists()) {
      await recipeImagesDir.create(recursive: true);
    }

    // Générer un nom de fichier unique (utilise l'ID de la recette ou timestamp)
    final String fileName = '${widget.widget.recette.id}.jpg';
    final String permanentPath = '${recipeImagesDir.path}/$fileName';

    // Copier le fichier vers le répertoire permanent
    final File sourceFile = File(sourcePath);
    await sourceFile.copy(permanentPath);

    return permanentPath;
  }

  Future<void> _cropImage() async {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: themeScheme.primary,
            toolbarWidgetColor: themeScheme.onPrimary,
            initAspectRatio: CropAspectRatioPresetCustom(),
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPresetCustom(),
            ],
            hideBottomControls: true),
        IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPresetCustom(),
            ],
            aspectRatioPickerButtonHidden: true),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 780,
          ),
        ),
      ],
    );
    if (croppedFile != null) {
      final String permanentPath =
          await _saveImagePermanently(croppedFile.path);

      setState(() {
        _croppedFile = croppedFile;
        _savedImagePath = permanentPath; // Stocker le chemin permanent
      });
    }
  }

  Future<void> _uploadImage({String source = "gallery"}) async {
    final pickedFile = await ImagePicker().pickImage(
        source: source == "gallery" ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
    _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    bool isPhoneSized = MediaQuery.of(context).size.width < 600;
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Form(
      key: widget._formKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Seulement si on clique sur l'arrière-plan
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //
              // Title Display
              TextField(
                controller: nameController,
                themeScheme: themeScheme,
                fillColor: themeScheme.surfaceContainer,
                hintText: "Name of the recipe",
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700),
                validation: true,
              ),
              //
              //Photo + brief + link display
              Builder(
                builder: (context) {
                  return const SizedBox.shrink(); // Placeholder widget
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CropperBody(
                      croppedFile: _croppedFile,
                      onUploadFromGallery: () =>
                          _uploadImage(source: "gallery"),
                      onUploadFromCamera: () => _uploadImage(source: "camera")),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: linkController,
                          themeScheme: themeScheme,
                          fillColor: themeScheme.surfaceContainerLow,
                          hintText: 'Website link -if relevant',
                          labelText: '(Website link)',
                          textStyle: Theme.of(context).textTheme.bodyMedium!,
                          multilignes: 1,
                          validation: false,
                        ),
                        TextField(
                          controller: descriptionController,
                          themeScheme: themeScheme,
                          fillColor: themeScheme.surfaceContainerLow,
                          hintText: 'Short description',
                          textStyle: Theme.of(context).textTheme.bodyMedium!,
                          validation: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //
              // DishType Display
              TextButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isDishTypeExpanded =
                        !isDishTypeExpanded; // Toggle visibility
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CategoryTitleBloc(cat: "Dish type(s)"),
                    Icon(
                      isDishTypeExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 30,
                      color: themeScheme.tertiary,
                    ),
                  ],
                ),
              ),
              isPhoneSized
                  ? GridView.count(
                      // DishType
                      padding: EdgeInsets.only(top: 10),
                      crossAxisCount: 3, // Number of columns
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 2.5,
                      shrinkWrap:
                          true, // Ensures the grid doesn't expand infinitely
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                      children: RecipesDico.dishTypes.where((dish) {
                        return isDishTypeExpanded ||
                            _tempDishTypes.contains(dish);
                      }).map((dish) {
                        return ChoiceChip(
                          label: Text(dish.capitalize()),
                          selected: _tempDishTypes.contains(dish),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _tempDishTypes.add(dish);
                              } else {
                                _tempDishTypes.remove(dish);
                              }
                            });
                          },
                        );
                      }).toList(),
                    )
                  : Wrap(
                      spacing: 10,
                      // Computer-sized screen
                      children: RecipesDico.dishTypes.where((dish) {
                        return isDishTypeExpanded ||
                            _tempDishTypes.contains(dish);
                      }).map((dish) {
                        return ChoiceChip(
                          label: Text(dish.capitalize()),
                          selected: _tempDishTypes.contains(dish),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _tempDishTypes.add(dish);
                              } else {
                                _tempDishTypes.remove(dish);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
              //
              // Utensils Display
              TextButton(
                onPressed: () {
                  setState(() {
                    isUtensilsExpanded =
                        !isUtensilsExpanded; // Toggle visibility
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CategoryTitleBloc(cat: "Necessary cookware"),
                    Icon(
                      isUtensilsExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 30,
                      color: themeScheme.tertiary,
                    ),
                  ],
                ),
              ),
              isPhoneSized
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 10,
                        // Computer-sized screen
                        children: RecipesDico.kitchenGear.where((gear) {
                          return isUtensilsExpanded ||
                              _tempUtensils.contains(gear.name);
                        }).map((gear) {
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(gear.icon),
                                Text(gear.name.capitalize()),
                              ],
                            ),
                            selected: _tempUtensils.contains(gear.name),
                            onSelected: (selected) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                if (selected) {
                                  _tempUtensils.add(gear.name);
                                } else {
                                  _tempUtensils.remove(gear.name);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : Wrap(
                      spacing: 10,
                      // Computer-sized screen
                      children: RecipesDico.kitchenGear.where((gear) {
                        return isUtensilsExpanded ||
                            _tempUtensils.contains(gear.name);
                      }).map((gear) {
                        return ChoiceChip(
                          label: Row(
                            children: [
                              Icon(gear.icon),
                              Text(gear.name.capitalize()),
                            ],
                          ),
                          selected: _tempUtensils.contains(gear.name),
                          onSelected: (selected) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              if (selected) {
                                _tempUtensils.add(gear.name);
                              } else {
                                _tempUtensils.remove(gear.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
              //
              // Ingredients display
              TextButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isIngredientExpanded =
                        !isIngredientExpanded; // Toggle visibility
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CategoryTitleBloc(cat: "Ingredients"),
                    Icon(
                      isIngredientExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 30,
                      color: themeScheme.tertiary,
                    ),
                  ],
                ),
              ),
              if (isIngredientExpanded) ...[
                Column(children: [
                  if (_tempIngredients.isNotEmpty) ...[
                    Column(
                        //Forbidden ingredients bloc
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var ingredient in _tempIngredients.keys)
                            IngredientElement(
                                initialValue:
                                    _tempIngredients[ingredient].toString(),
                                ingredient: ingredient,
                                onPressed: () => {
                                      _tempIngredients.remove(ingredient),
                                      setState(() {})
                                    },
                                onChanged: (val) {
                                  try {
                                    _tempIngredients[ingredient] =
                                        double.parse(val);
                                  } catch (e) {
                                    print(
                                        "$val ne peut pas être converti en double: $e");
                                  }
                                  setState(() {});
                                }),
                        ]),
                  ],
                  if (!_isAddingIngredient)
                    (TextButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _isAddingIngredient = true;
                        });
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.add_circle_outline,
                          size: 25,
                        ),
                        title: Row(
                          children: [
                            Text("Add ingredient"),
                          ],
                        ),
                        iconColor: themeScheme.onTertiaryFixedVariant,
                        textColor: themeScheme.onTertiaryFixedVariant,
                      ),
                    ))
                  else
                    FocusScope(
                      child: Column(
                        children: [
                          InputIngredient(
                            add: (String selection) {
                              _tempIngredients[selection] = 0;
                              setState(() {
                                _isAddingIngredient =
                                    false; // Retour au bouton après ajout
                              });
                            },
                            onCancel: () {
                              setState(() {
                                _isAddingIngredient = false;
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isAddingIngredient = false;
                              });
                            },
                            child: Text("Cancel",
                                style: TextStyle(color: themeScheme.error)),
                          ),
                        ],
                      ),
                    ),
                ]),
              ] else
                Wrap(
                  children: _tempIngredients.keys.map((ing) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(
                        backgroundColor: themeScheme.tertiaryContainer,
                        label: Text(
                            "$ing: ${_tempIngredients[ing].toString().endsWith('.0') ? _tempIngredients[ing].toString().substring(0, _tempIngredients[ing].toString().length - 2) : _tempIngredients[ing]}${ingredientsDict[ing]!['unit']}"),
                      ),
                    );
                  }).toList(),
                ),
              //
              // Section Steps
              TextButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    isStepExpanded = !isStepExpanded;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CategoryTitleBloc(cat: "Steps"),
                    Icon(
                      isStepExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 30,
                      color: themeScheme.tertiary,
                    ),
                  ],
                ),
              ),

              if (isStepExpanded) ...[
                // Liste des steps avec réorganisation
                if (_tempSteps.isNotEmpty)
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _tempSteps.length,
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget? child) {
                          final double animValue =
                              Curves.easeInOut.transform(animation.value);
                          final double elevation = lerpDouble(0, 6, animValue)!;
                          final double scale = lerpDouble(1, 1.02, animValue)!;

                          return Transform.scale(
                            scale: scale,
                            child: Material(
                              elevation: elevation,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                    (themeScheme.tertiary.r * 255).floor(),
                                    (themeScheme.tertiary.g * 255).floor(),
                                    (themeScheme.tertiary.b * 255).floor(),
                                    0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: themeScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: child,
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final step = _tempSteps.removeAt(oldIndex);
                        _tempSteps.insert(newIndex, step);
                      });
                    },
                    itemBuilder: (context, index) {
                      final step = _tempSteps[index];
                      if (_editingStepIndex == index) {
                        return Container(
                          key: ValueKey(step.hashCode),
                          child: StepEditor(
                            step: step, // Passer le step existant
                            onSave: (editedStep) {
                              setState(() {
                                _tempSteps[index] =
                                    editedStep; // Remplacer le step
                                _editingStepIndex = null; // Fermer l'éditeur
                              });
                            },
                            onCancel: () {
                              setState(() {
                                _editingStepIndex =
                                    null; // Fermer sans sauvegarder
                              });
                            },
                          ),
                        );
                      }

                      return Card(
                        key: ValueKey(step
                            .hashCode), // Important pour ReorderableListView
                        margin: EdgeInsets.fromLTRB(5, 4, 16, 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                          selectedTileColor: themeScheme.onTertiaryFixed,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.drag_handle), // Icône pour drag
                              SizedBox(width: 6),
                              CircleAvatar(
                                backgroundColor:
                                    step.type == StepType.preparation
                                        ? themeScheme.primaryContainer
                                        : themeScheme.tertiaryContainer,
                                child: Text('${index + 1}'),
                              ),
                            ],
                          ),
                          title: TextButton(
                              onPressed: () {
                                setState(() {
                                  _editingStepIndex = index;
                                });
                              },
                              child: Text(step.description)),
                          subtitle: Text(
                              '${step.type.name} • ${step.duration?.inMinutes} min'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: themeScheme.error),
                            onPressed: () {
                              setState(() {
                                _tempSteps.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),

                // Bouton ou formulaire d'ajout
                if (_editingStepIndex == null) ...[
                  if (!_isAddingStep)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isAddingStep = true;
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.add_circle_outline, size: 25),
                        title: Text("Add step"),
                      ),
                    )
                  else
                    StepEditor(
                      onSave: (step) {
                        setState(() {
                          _tempSteps.add(step);
                          _isAddingStep = false;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          _isAddingStep = false;
                        });
                      },
                    ),
                ],
              ],

              ////
              //Save Button
              //
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (widget._formKey.currentState!.validate()) {
                        Recipe nouvelleRecette = Recipe(
                          id: widget.widget.recette.id,
                          name: nameController.text,
                          image: _savedImagePath ??
                              widget.widget.recette
                                  .image, // Utiliser le chemin permanent
                          summary: descriptionController.text,
                          recipeLink: linkController.text,
                          ingredients: _tempIngredients,
                          steps: _tempSteps,
                          servings: widget.widget.recette.servings,
                          dishTypes: _tempDishTypes,
                          necessaryGear: _tempUtensils,
                          personalized: widget.widget.recette.personalized,
                        );

                        myRecipes.addRecipe(nouvelleRecette);
                        recipesDict.reloadTheirRecipes();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save recipe'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextField extends StatefulWidget {
  TextField({
    super.key,
    required this.controller,
    required this.themeScheme,
    required this.fillColor,
    required this.hintText,
    required this.textStyle,
    required this.validation,
    labelText,
    focusColor,
    this.multilignes,
    this.focusedBorderWidth = 2,
  })  : focusColor = focusColor ?? fillColor,
        labelText = labelText ?? hintText;

  final TextEditingController controller;
  final ColorScheme themeScheme;
  final Color fillColor;
  final Color focusColor;
  final String hintText;
  final String labelText;
  final TextStyle textStyle;
  final bool validation;
  final int? multilignes;

  final double focusedBorderWidth;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final ScrollController _scrollControllerA = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Add a FocusNode
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Trigger animation when the field loses focus
        _scrollControllerA.animateTo(
          0.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the FocusNode
    _scrollControllerA.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPhoneSized = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        //Name
        controller: widget.controller,
        scrollController: _scrollControllerA,
        focusNode: _focusNode,
        //initialValue: widget.widget.recette.name,
        maxLines: widget.multilignes,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            filled: true,
            fillColor: widget.fillColor,
            focusColor: widget.focusColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
                gapPadding: 0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    width: widget.focusedBorderWidth,
                    color: widget.themeScheme.primary),
                gapPadding: 0),
            labelText: FocusScope.of(context).hasFocus
                ? widget.labelText
                : widget.hintText,
            hintText:
                (widget.controller.text == "") ? "" : widget.controller.text),
        textAlign: isPhoneSized ? TextAlign.center : TextAlign.start,
        style: widget.textStyle,
        validator: widget.validation
            ? (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              }
            : null,
      ),
    );
  }
}
