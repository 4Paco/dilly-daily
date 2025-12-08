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

## Useful data

### Color theme

- "dark violet' = theme.colorScheme.primary (RGB = (132, 76, 114), HEX = #844c72)
- 'light orange' = theme.colorScheme.tertiaryFixed (RGB = (252, 227, 217), HEX= #fce3d9)
- 'no-so-light orange' = theme.colorScheme.tertiaryFixedDim (RGB = (244,185,160), HEX= #f4b9a0)
- 'brown' = theme.colorScheme.tertiary
  p

## Our promises :

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

## Git pour les noobs

### Les commandes de base

Récupérer les modifs faites par les autres :

> git pull

Enregistrer tes modifs :

> git add .
>
> git commit -m "message qui explique la nature de tes modifs"

Publier tes modifs : [IMPORTANT] Vérifie que l'app n'est pas cassée avant de faire un git push

> git push

### Revenir en arrière - Ctrl-Z

Tu ne sais pas ce que tu as fait mais ça a tout cassé ? Tu peux tout effacer et revenir à ton dernier commit avec :

> git stash

Si ton dernier commit est cassé, tu peux tenter

> git reset --hard HEAD~

Si tout tout est cassé et que tu voudrais juste tout effacer et repartir sur des bases saines, les commandes suivantes effacent ce qu'il y a sur ton ordi et reprennent juste le code commun qui a été publié (via les push)

> git fetch origin
>
> git reset --hard origin/main
>
> git clean -f

Si après tout ça c'est encore cassé

1. Le problème vient peut-être de toi/de ton ordi et pas du code
2. Envoie un message accusateur sur le groupe pour shame celle.ui qui a push une app cassée
3. Il va falloir remonter dans les logs trouver une version du code pas cassée
   > git log (=> find and copy the complicated name of the commit you want to go back to, something like 9dc4e82...)
   >
   > q (=> it will get you out of the git log interface)
   >
   > git reset --hard [complicated name] (=> you could also try "git reset --soft [commit]" if you don't want to delete the changes)
   >
   > git push -u origin main -f

### Créer une branche

Quand tu te lances sur une modif dans le projet et que tu sais que tu risques de casser quelques trucs pendant le process, le mieux est de créer ta 🔸branche🔸 pour ça (Une branche correspond juste à une "copie" safe du projet sur laquelle tu peux travailler dans ton coin et tout casser sans t'inquiéter)

> git checkout -b "nom_de_ta_branche"

(si tu ne l'as jamais fait, je te recommande d'utiliser la commande suivante qui permet de faciliter ta prise en main des branches)

> git config --global push.autoSetupRemote true

### Merge une branche

Quand tu as fini de bosser sur tes modifs, il est temps de rajouter tout ça sur le code principal !
Tout d'abord, n'oublie pas de "git push" les dernières modifs de ta branche
Ensuite :

> git chekout main
>
> git merge "nom_de_ta_branche"

Avec un peu de chance, à ce moment là tout fonctionne bien et l'interface te demande juste de faire un commit pour conclure le merge
/!\ Vérifie que l'app n'est pas cassée avant de faire un git push

S'il y a des messages d'erreur parlant de "merge conflict"

1. Don't panic
2. > git status
3. Tous les fichiers problématiques sont affichés en rouge : va les ouvrir dans VS Code. Là tu peux trouver un "merge editor" plutôt bien fait, les bouts de code estampillés "HEAD" sont ceux qui étaient sur le code commun, il faut les comparer avec les bouts de code qui viennent de ta branche. Il faut le faire à la main, et choisir ce qui te semble le mieux :)
4. Une fois que tout est corrigé, tu enregistres bien tous les fichiers, et tu VÉRIFIES QUE L'APP N'EST PAS CASSÉE (si tout est cassé et que tu veux juste annuler ta tentative de merge, tu as toujours l'option d'utiliser la commande "git merge --abort")
5. Tu retournes ensuite dans le terminal :
   > git add .
   >
   > git commit -m "merge done !"
   >
   > git push

### Se repérer

Si tu ne sais plus le nom de ta branche, ou quels fichiers tu as modifiés :

> git status

Utile pour voir la liste des derniers commits :

> git log

(attention, il faut appuyer sur 'q' pour quitter les logs)
