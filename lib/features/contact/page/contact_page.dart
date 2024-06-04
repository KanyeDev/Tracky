import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(emailLaunchUri);
  }



  Future<void> _launchUrl(String urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
  }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We would love to hear from you! If you have any questions, feedback, or suggestions, please feel free to reach out to us through any of the channels below:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading:  Icon(Icons.email, color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Email Us'),
              subtitle: const Text('adekanyekabir@gmail.com'),
              onTap: () => _launchEmail('adekanyekabir@gmail.com'),
            ),
            ListTile(
              leading:  Icon(Icons.web, color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Visit Our Website'),
              subtitle: const Text('https://www.cyrexltd.com'),
              onTap: () => _launchUrl('https://www.cyrexltd.com'),
            ),
              ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Call Us'),
              subtitle: const Text('+2349054334521'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon:   Icon(FontAwesomeIcons.linkedinIn, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () => _launchUrl('https://www.linkedin.com/in/adekanye-abdulkabir-1a6095182'),
                ),
                IconButton(
                  icon:    Icon(FontAwesomeIcons.xTwitter, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () => _launchUrl('https://x.com/CyrexTech_'),
                ),
                IconButton(
                  icon:   Icon(FontAwesomeIcons.instagram, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () => _launchUrl('https://www.instagram.com/cyrex.tech'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
