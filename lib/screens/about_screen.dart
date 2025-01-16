import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.about_screen_title),
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
                context.l10n.app_name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Version $version',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Text(
                context.l10n.social_media_title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.flutter_dash),
                title: Text(context.l10n.twitter_title),
                subtitle: Text(context.l10n.twitter_handle),
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: AnalyticsEvents.aboutScreenTwitterTapped,
                  );
                  launchUrl(Uri.parse('https://twitter.com/accountantapp'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(context.l10n.instagram_title),
                subtitle: Text(context.l10n.instagram_handle),
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: AnalyticsEvents.aboutScreenInstagramTapped,
                  );
                  launchUrl(
                      Uri.parse('https://instagram.com/supersimpleaccountant'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(context.l10n.contact_title),
                subtitle: Text(context.l10n.contact_subtitle),
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: AnalyticsEvents.aboutScreenEmailTapped,
                  );
                  launchUrl(Uri.parse('mailto:supersimpleacc10@gmail.com'));
                },
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.copyright_text,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: AnalyticsEvents.aboutScreenWebsiteTapped,
                  );
                  launchUrl(Uri.parse('https://simpleaccountant.app'));
                },
                child: const Text(
                  'simpleaccountant.app',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
