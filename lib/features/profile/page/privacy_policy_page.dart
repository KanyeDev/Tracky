import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to Tracky! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this policy carefully.',
            ),
            SizedBox(height: 20),
            Text(
              'Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We may collect information about you in a variety of ways. The information we may collect via the app includes:',
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Personal Data'),
              subtitle: Text(
                'We collect personal data such as name, email address, phone number, and profile picture when you register for the app.',
              ),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Usage Data'),
              subtitle: Text(
                'We collect information about your usage of the app, including the habits you track and your interactions with the app.',
              ),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Device Data'),
              subtitle: Text(
                'We collect information about your device, such as mobile device ID, model, manufacturer, and operating system version.',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We use the information we collect in the following ways:',
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To provide and maintain our service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To notify you about changes to our service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To allow you to participate in interactive features of our service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To provide customer support'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To gather analysis or valuable information so that we can improve our service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To monitor the usage of our service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To detect, prevent, and address technical issues'),
            ),
            SizedBox(height: 20),
            Text(
              'Sharing Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We do not share your personal information with third parties except in the following circumstances:',
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('With your consent'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To comply with legal obligations'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To protect and defend our rights and property'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To prevent or investigate possible wrongdoing in connection with the service'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('To protect the personal safety of users of the service or the public'),
            ),
            SizedBox(height: 20),
            Text(
              'Security of Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse.',
            ),
            SizedBox(height: 20),
            Text(
              'Changes to This Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions about this Privacy Policy, please contact us:',
            ),
            Text(
              'Email: adekanyekabir@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Phone: +2349054334521',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
