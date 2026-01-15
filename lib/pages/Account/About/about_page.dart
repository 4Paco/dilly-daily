import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Fonction pour ouvrir l'URL
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $urlString'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Column(
                  children: [
                    // Remplace par ton logo si tu en as un
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF844c72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'DillyDaily',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF844c72),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Version 2.1.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Section: About the Project
              BlocTitle(texte: "À propos du projet"),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'DillyDaily est une application mobile pour la gestion de recettes, la planification de repas et les courses. '
                    'Créée dans le cadre du cours Design and Implementation of Mobile Applications à Politecnico di Milano, '
                    'elle vous aide à organiser vos repas efficacement tout en respectant les restrictions alimentaires et les ressources de cuisine disponibles.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section: Team
              BlocTitle(texte: "Équipe"),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Lyla Demange'),
                subtitle: Text('Développement Mobile'),
              ),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Marion Henriot'),
                subtitle: Text('Développement Mobile & Documentation'),
              ),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Nils Mittelhockamp'),
                subtitle: Text('Développement Mobile & Tests'),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.school, color: Color(0xFF844c72)),
                title: Text('Supervisé par'),
                subtitle: Text('Professeur Luciano Baresi'),
              ),

              const SizedBox(height: 24),

              // Section: Technologies
              BlocTitle(texte: "Technologies"),
              const SizedBox(height: 8),
              const Card(
                  child: ListBody(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.phone_android, color: Color(0xFF844c72)),
                    title: Text('Flutter & Dart'),
                    subtitle: Text('Framework mobile multiplateforme'),
                  ),
                  ListTile(
                    leading: Icon(Icons.cloud, color: Color(0xFF844c72)),
                    title: Text('FastAPI'),
                    subtitle: Text(
                        'Serveur backend pour la base de données de recettes'),
                  ),
                  ListTile(
                    leading: Icon(Icons.storage, color: Color(0xFF844c72)),
                    title: Text('Render'),
                    subtitle: Text('Plateforme d\'hébergement cloud'),
                  ),
                  ListTile(
                    leading: Icon(Icons.analytics, color: Color(0xFF844c72)),
                    title: Text('Microsoft Clarity'),
                    subtitle: Text('Analyse du comportement des utilisateurs'),
                  ),
                ],
              )),

              const SizedBox(height: 24),

              // Section: Links
              BlocTitle(texte: "Links"),
              const SizedBox(height: 8),
              ListTile(
                leading:
                    const Icon(Icons.description, color: Color(0xFF844c72)),
                title: const Text('Documentation'),
                subtitle: const Text('Voir notre design document'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  _launchURL(context,
                      'https://github.com/4Paco/dilly-daily/blob/a821fcd1ee335d8f13561d997905065a766a6e70/design_doc/DIMA_%20Design%20Document%20of%20DillyDaily%20.pdf');
                },
              ),
              ListTile(
                leading: const Icon(Icons.code, color: Color(0xFF844c72)),
                title: const Text('GitHub Repository'),
                subtitle: const Text('Voir le code source'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  _launchURL(context, 'https://github.com/4Paco/dilly-daily');
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback, color: Color(0xFF844c72)),
                title: const Text('Questionnaire Feedback'),
                subtitle: const Text('Partage tes impressions !'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  _launchURL(
                      context, 'https://form.jotform.com/260043782208352');
                },
              ),

              const SizedBox(height: 24),

              // Section: Legal
              BlocTitle(texte: "Legal"),
              const SizedBox(height: 8),
              ListTile(
                leading:
                    const Icon(Icons.privacy_tip, color: Color(0xFF844c72)),
                title: const Text('Privacy Policy'),
                subtitle: const Text('Your data stays on your device'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Privacy Policy'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'DillyDaily stores all your personal data locally on your device. '
                          'We do not collect, store, or share any personally identifiable information. '
                          'The app only connects to our server to download the recipe database at startup. '
                          '\n\nAnonymous usage analytics are collected via Microsoft Clarity to help us improve the app experience.',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.article, color: Color(0xFF844c72)),
                title: const Text('Open Source Licenses'),
                subtitle: const Text('View third-party licenses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'DillyDaily',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF844c72),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Made with ❤️ at Politecnico di Milano',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2026 DillyDaily Team',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }
}
