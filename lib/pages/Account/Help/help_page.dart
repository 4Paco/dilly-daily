import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  // Fonction pour ouvrir l'URL
  Future<void> _launchFeedbackForm(BuildContext context) async {
    final Uri url = Uri.parse('https://form.jotform.com/260043782208352');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open feedback form'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFAQDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Section FAQ
                BlocTitle(texte: 'FAQ'),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('Comment ajouter une recette à mon Menu ?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Ajouter une recette au Menu',
                    'Accédez à la page Explorer, appuyez sur une recette pour l\'afficher, puis cliquez sur le bouton "Ajouter". La recette apparaîtra dans le carrousel de votre menu où vous pourrez la glisser vers n\'importe quel jour et créneau repas.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('Comment modifier ma Semaine ?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Drad&Drop',
                    'Dans la page Menu, appuyez longuement sur une recette du carrousel ou de la chronologie, puis faites-la glisser vers le créneau repas souhaité. Vous pouvez également déplacer des recettes entre les créneaux pour réorganiser votre semaine.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text(
                      'Pourquoi certaines recettes ne s\'affichent pas ?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Filtrage des recettes',
                    'Les recettes sont automatiquement filtrées en fonction de vos restrictions alimentaires, de l\'équipement disponible et de votre niveau de patience en cuisine. Vous pouvez désactiver ces filtres en appuyant sur l\'icône à droite de la barre de recherche dans la page Explorer.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('Comment modifier mes recettes ?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Modifier les recettes',
                    'Depuis la page "Créer" ou "Explorer", appuyez sur une recette pour ouvrir son aperçu, puis cliquez sur l\'icône d\'édition (crayon) en haut à droite. Vous pouvez modifier tous les champs et enregistrer vos modifications.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('Comment générer ma liste de courses ?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Liste de courses',
                    'Ouvrez une recette de votre Menu, ajustez la quantité avec les boutons +/- puis appuyez sur "Ajouter aux courses". Les ingrédients seront automatiquement ajoutés à votre liste de courses dans la page Courses.',
                  ),
                ),

                const Divider(height: 32),

                // Section Tutorials
                BlocTitle(texte: "Getting started"),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Configurer votre profil de cuisine'),
                  subtitle:
                      const Text('Définissez vos préférences et restrictions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Profil de Cuisine',
                    'Accédez à Compte → Mon Profil pour définir le nombre de portions que vous cuisinez et votre niveau de patience en cuisine. Rendez-vous dans Préférences Alimentaires pour configurer vos restrictions alimentaires et allergies.',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Planifiez votre première semaine'),
                  subtitle: const Text(
                      'Apprenez à utiliser la fonctionnalité de planification des repas'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Planification des repas',
                    '1. Parcourez les recettes dans Explorer\n2. Ajoutez vos favoris à votre Menu\n3. Glissez les recettes vers des jours et créneaux spécifiques\n4. Générez votre liste de courses à partir des repas planifiés',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Créer votre première recette'),
                  subtitle: const Text(
                      'Ajoutez des recettes personnalisées à votre collection'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Créer une recette',
                    'Accédez à la page Créer, cliquez sur le bouton "+", remplissez le nom de la recette, ajoutez les ingrédients et les étapes, ajoutez éventuellement une photo, puis enregistrez. Votre recette apparaîtra dans Créer et dans vos résultats de recherche.',
                  ),
                ),

                const Divider(height: 32),

                // Section Feedback & Contact
                BlocTitle(texte: "Feedback & Support"),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Envoyer des commentaires'),
                  subtitle:
                      const Text('Partagez vos suggestions ou signalez un bug'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _launchFeedbackForm(context),
                ),

                ListTile(
                  leading: const Icon(Icons.email_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Nous contacter'),
                  subtitle: const Text('marion.henriot@mail.polimit.it'),
                  trailing: const Icon(Icons.copy),
                  onTap: () {
                    // Copier l'email dans le presse-papier (optionnel)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email copié dans le presse-papier'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const Divider(height: 32),

                // Section Troubleshooting
                BlocTitle(texte: "Dépannage"),

                ListTile(
                  leading: const Icon(Icons.refresh, color: Color(0xFF844c72)),
                  title:
                      const Text('L\'application ne charge pas les recettes ?'),
                  subtitle: const Text(
                      'Vérifiez votre connexion Internet au démarrage'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Problèmes de chargement',
                    'DillyDaily nécessite une connexion Internet lors du premier lancement pour télécharger la base de données des recettes. Ensuite, vous pouvez utiliser l\'application hors ligne. Essayez de redémarrer l\'application avec une connexion stable.',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.storage_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Les données ne sont pas sauvegardées ?'),
                  subtitle: const Text(
                      'Vérifiez les autorisations de l\'application'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Autorisations de stockage',
                    'Assurez-vous que DillyDaily a l\'autorisation d\'accéder au stockage de votre appareil. Allez dans les Paramètres de votre appareil → Applications → DillyDaily → Permissions et activez l\'accès au stockage.',
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
