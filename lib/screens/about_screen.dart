import 'package:flutter/material.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.hasData ? snapshot.data!.version : '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 50,
                child: Image.asset(Assets.appIconRounded, scale: 2),
              ),
              const SizedBox(height: 16),
              Text(
                'Super Simple Accountant',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Version $version',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'Follow us on Social Media!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.flutter_dash),
                title: const Text('Twitter'),
                subtitle: const Text('@AccountantApp'),
                onTap: () => launchUrl(
                  Uri.parse('https://twitter.com/accountantapp'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Instagram'),
                subtitle: const Text('@supersimpleaccountant'),
                onTap: () => launchUrl(
                  Uri.parse('https://instagram.com/supersimpleaccountant'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Contact'),
                subtitle: const Text('Send us an email'),
                onTap: () => launchUrl(
                  Uri.parse('mailto:supersimpleacc10@gmail.com'),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '© 2024 Super Simple Accountant\nAll rights reserved.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
