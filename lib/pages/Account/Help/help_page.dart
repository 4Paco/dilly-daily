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
                BlocTitle(texte: 'Frequently Asked Questions'),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('How do I add a recipe to my meal plan?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Add Recipe to Meal Plan',
                    'Go to the Explore page, tap on a recipe to preview it, then click the "Add" button. The recipe will appear in your Meal Plan carousel where you can drag it to any day and meal slot.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('How does drag-and-drop work?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Drag-and-Drop',
                    'In the Meal Plan page, long-press on a recipe from the carousel or timeline, then drag it to your desired meal slot. You can also drag recipes between slots to reorganize your week.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('Why don\'t I see some recipes?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Recipe Filtering',
                    'Recipes are automatically filtered based on your dietary restrictions, available equipment, and cooking patience level. You can disable these filters by tapping the settings icon on the Explore page.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('How do I edit my custom recipes?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Edit Recipes',
                    'Tap on any recipe to open its preview, then click the edit icon (pencil) in the top right corner. You can modify all fields and save your changes.',
                  ),
                ),

                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF844c72)),
                  title: const Text('How do I generate my grocery list?'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Grocery List',
                    'Open a recipe from your Meal Plan, adjust the quantity with +/- buttons, then tap "Add to Groceries". The ingredients will be automatically added to your shopping list in the Groceries page.',
                  ),
                ),

                const Divider(height: 32),

                // Section Tutorials
                BlocTitle(texte: "Getting started"),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Set up your cooking profile'),
                  subtitle:
                      const Text('Configure your preferences and restrictions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Cooking Profile',
                    'Go to Account → My Cooking Profile to set the number of portions you cook for and your cooking patience level. Visit Special Diet to configure dietary restrictions and allergens.',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Plan your first week'),
                  subtitle:
                      const Text('Learn to use the meal planning feature'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Meal Planning',
                    '1. Browse recipes in Explore\n2. Add favorites to your Meal Plan\n3. Drag recipes to specific days and meal slots\n4. Generate your grocery list from planned meals',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Create your first recipe'),
                  subtitle:
                      const Text('Add personalized recipes to your collection'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Create Recipe',
                    'Go to the Write page (+ tab), fill in the recipe name, add ingredients and steps, optionally add a photo, then save. Your recipe will appear in Explore with a "My recipes" badge.',
                  ),
                ),

                const Divider(height: 32),

                // Section Feedback & Contact
                BlocTitle(texte: "Feedback & Support"),

                ListTile(
                  leading: const Icon(Icons.feedback_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Send Feedback'),
                  subtitle:
                      const Text('Share your suggestions or report a bug'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _launchFeedbackForm(context),
                ),

                ListTile(
                  leading: const Icon(Icons.email_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Contact Us'),
                  subtitle: const Text('marion.henriot@mail.polimit.it'),
                  trailing: const Icon(Icons.copy),
                  onTap: () {
                    // Copier l'email dans le presse-papier (optionnel)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const Divider(height: 32),

                // Section Troubleshooting
                BlocTitle(texte: "Troubleshooting"),

                ListTile(
                  leading: const Icon(Icons.refresh, color: Color(0xFF844c72)),
                  title: const Text('App not loading recipes?'),
                  subtitle:
                      const Text('Check your internet connection at startup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Loading Issues',
                    'DillyDaily needs an internet connection when you first open the app to download the recipe database. After that, you can use the app offline. Try restarting the app with a stable connection.',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.storage_outlined,
                      color: Color(0xFF844c72)),
                  title: const Text('Data not saving?'),
                  subtitle: const Text('Check app permissions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFAQDialog(
                    context,
                    'Storage Permissions',
                    'Make sure DillyDaily has permission to access storage on your device. Go to your device Settings → Apps → DillyDaily → Permissions and enable storage access.',
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
