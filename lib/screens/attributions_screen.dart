import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionsScreen extends StatelessWidget {
  const AttributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attributions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAttributionSection(
            'Google Icon',
            'Icons8',
            'https://icons8.com/icon/V5cGWnc9R4xj/google',
            'https://icons8.com',
          ),
          const SizedBox(height: 24),
          _buildAttributionSection(
            'Auth Illustration',
            'storyset on Freepik',
            'https://www.freepik.com/free-vector/phone-customization-concept-illustration_11394711.htm',
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildAttributionSection(
    String title,
    String author,
    String assetUrl,
    String? authorUrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () => _launchUrl(assetUrl),
              child: const Text(
                'View Asset',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(' by '),
            if (authorUrl != null)
              GestureDetector(
                onTap: () => _launchUrl(authorUrl),
                child: Text(
                  author,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            else
              Text(author),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
