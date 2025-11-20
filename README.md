# DillyDaily
> Recipe management app

## File organization
- lib > main.dart is the main file, implementing the navigation between pages
- Each page has its \[page name]_page.dart file
- Classes managing the 'fetch data' part are in dilly_daily > lib > data
- For the time being, the 'databases' of ingredients/recipes are in dilly_daily > assets > data
- For the time being, the user preferences are created/stored locally on the device (not in the project)

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

### Activate dev mode on android phone

- Go in Settings > À propos du téléphone > Infos sur le logiciel
- Cliquer 7 fois sur n° de version / n° de build et activer le mode développeur
- Aller dans Settings > Options de développement
- Activer le débogage USB (ça permet de pouvoir brancher ton tel sur ton ordi et tester l'app en temps réel dessus)


## TODO 

### (ongoing) :

- change "Home" for "My recipes" (interface to edit and write recipes)
- flesh out the "+" button in groceries page
- personalized baseline grocery list

### (at some point) :

- work on the server
- "download" recipes added to meal plan (aka write them in a file)
- create an interface to write in recipes from the app

