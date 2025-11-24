# DillyDaily

> Recipe management app

## File organization

- lib > main.dart is the main file, implementing the navigation between pages
- Each page has its \[page name]\_page.dart file
- Classes managing the 'fetch data' part are in dilly_daily > lib > data
- For the time being, the 'databases' of ingredients/recipes can still be found in dilly_daily > assets > data
- For the time being, the user preferences are created/stored locally on the device (not in the project). See lib>data>personalisation.dart for all classes/objects relative to user custom preferences (their own recipes, their allergies, ...)

## Developer info

### Start with flutter (set-up)

https://docs.flutter.dev/get-started/quick

### Launch the app

- Open a terminal in the dilly_daily folder
- Run : flutter run
- If you connected your phone to your computer, it will automatically launch the app on the phone (see 'Activate dev mode' section if it doesn't recognize your phone)
- Else, you can choose the 'Chrome' option to launch the app in your navigator

### Better way to launch the app

- Open dilly_daily > lib > main.dart file in VSCode
- In the top of the screen, select Run > Start debugging
- (you might have to restart once to see your latest changes)

### I want to launch the app with my latest changes (without having to restart it)

- open the folder dilly_daily in a terminal
- run :
  > flutter clean
  > flutter pub get

### Activate dev mode on your android phone

- Go in Settings > À propos du téléphone > Infos sur le logiciel
- Cliquer 7 fois sur n° de version / n° de build et activer le mode développeur
- Aller dans Settings > Options de développement
- Activer le débogage USB (ça permet de pouvoir brancher ton tel sur ton ordi et tester l'app en temps réel dessus)

## TODO

### (ongoing) :

- \[urgent] change the management of stateful/stateless widgets/variables O_o
- update Recipe database to use str keys (uuid)
- change "Home" for "My recipes" (interface to edit and write recipes)
  - my recipes is already an object created in personalization.dart (MyRecipes is a custom class with its main feature being a dictionary of Recipes objects)(all those classes are also declared in personalization.dart)
- flesh out the "+" button in groceries page
- personalized baseline grocery list (in preferences ? _And_ in the + button ?)

### (at some point) :

- "download" recipes added to meal plan (aka write them in a file)
- create an interface to write in recipes from the app

### our promises :

Our project will include several screens :

- **Authentication** screen
- **Home** screen - allowing the user to browse through a recipe database, and look for recipes with different filters (price, ingredients, time, friends only recipes…)
- **Meal Plan** screen - where the user can organize their meals for the week (and grow their grocery list)
- **Edited/Created recipes** screen - the user can create their own recipes or copy someone else’s recipe and adjust it to their own preferences
- **Grocery List** screen - Automatically generated from selected recipes ; the user can add their own items to the list. This screen will be designed to be usable in the grocery store (with dynamic checking off of the items)
- **Cooking** Screen - simple step-by-step of the recipe
- **Personalization** screen
  - **Food restriction** screen - where the user can select their food restrictions (allergies or special diet) (it will be used to automatically filter out the recipes visible in the Home Page)
  - **Cooking profile** screen - where the user can indicate which cooking equipment they own, what time and energy they can spend cooking, the number of people in their household… It will also be used to automatically filter out the recipes to allow optimized browsing for the user
  - **Friends** screen - where the user can add their friends using the app, and check out the recipes they created.

### What could be cool :

- recommendation system
- save preferences somewhere else than locally
-
