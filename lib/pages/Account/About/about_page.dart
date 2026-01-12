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
                      'Version 1.0.0',
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
              BlocTitle(texte: "About the Project"),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'DillyDaily is a mobile application for recipe management, meal planning, and grocery shopping. '
                    'Created as part of the Design and Implementation of Mobile Applications course at Politecnico di Milano, '
                    'it helps you organize your meals efficiently while respecting dietary restrictions and available cooking resources.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section: Team
              BlocTitle(texte: "Team"),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Lyla Demange'),
                subtitle: Text('Mobile Development'),
              ),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Marion Henriot'),
                subtitle: Text('Mobile Development & Documentation'),
              ),
              const ListTile(
                leading: Icon(Icons.person, color: Color(0xFF844c72)),
                title: Text('Nils Mittelhockamp'),
                subtitle: Text('Mobile Development & Testing'),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.school, color: Color(0xFF844c72)),
                title: Text('Supervised by'),
                subtitle: Text('Professor Luciano Baresi'),
              ),

              const SizedBox(height: 24),

              // Section: Technologies
              BlocTitle(texte: "Built With"),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.phone_android, color: Color(0xFF844c72)),
                title: Text('Flutter & Dart'),
                subtitle: Text('Cross-platform mobile framework'),
              ),
              const ListTile(
                leading: Icon(Icons.cloud, color: Color(0xFF844c72)),
                title: Text('FastAPI'),
                subtitle: Text('Backend server for recipe database'),
              ),
              const ListTile(
                leading: Icon(Icons.storage, color: Color(0xFF844c72)),
                title: Text('Render'),
                subtitle: Text('Cloud hosting platform'),
              ),
              const ListTile(
                leading: Icon(Icons.analytics, color: Color(0xFF844c72)),
                title: Text('Microsoft Clarity'),
                subtitle: Text('User behavior analytics'),
              ),

              const SizedBox(height: 24),

              // Section: Credits
              BlocTitle(texte: "Credits & Acknowledgments"),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Icons: Material Design Icons',
                        style: TextStyle(fontSize: 15, height: 1.8),
                      ),
                      Text(
                        '• Flutter packages: image_picker, url_launcher, path_provider, and others',
                        style: TextStyle(fontSize: 15, height: 1.8),
                      ),
                      Text(
                        '• Special thanks to all beta testers who provided valuable feedback',
                        style: TextStyle(fontSize: 15, height: 1.8),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section: Links
              BlocTitle(texte: "Links"),
              const SizedBox(height: 8),
              ListTile(
                leading:
                    const Icon(Icons.description, color: Color(0xFF844c72)),
                title: const Text('Documentation'),
                subtitle: const Text('View full design document'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  _launchURL(context, 'https://github.com/4Paco/dilly-daily');
                },
              ),
              ListTile(
                leading: const Icon(Icons.code, color: Color(0xFF844c72)),
                title: const Text('GitHub Repository'),
                subtitle: const Text('View source code'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  _launchURL(context, 'https://github.com/4Paco/dilly-daily');
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback, color: Color(0xFF844c72)),
                title: const Text('Feedback Form'),
                subtitle: const Text('Share your thoughts'),
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
