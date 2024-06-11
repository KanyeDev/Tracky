import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
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
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to Tracky! These Terms and Conditions govern your use of our mobile application. By accessing or using the app, you agree to be bound by these terms. If you do not agree to these terms, please do not use the app.',
            ),
            SizedBox(height: 20),
            Text(
              'User Accounts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our service.',
            ),
            SizedBox(height: 20),
            Text(
              'Prohibited Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You agree not to engage in any of the following prohibited activities:',
            ),

            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Using any automated system to access the app in a manner that sends more request messages to the app servers than a human can reasonably produce in the same period of time'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Attempting to interfere with, compromise the system integrity or security, or decipher any transmissions to or from the servers running the app'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Taking any action that imposes an unreasonable or disproportionately large load on our infrastructure'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Uploading invalid data, viruses, worms, or other software agents through the app'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Collecting or harvesting any personally identifiable information from the app'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Impersonating another person or otherwise misrepresenting your affiliation with a person or entity'),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Engaging in any conduct that restricts or inhibits anyone’s use or enjoyment of the app, or which, as determined by us, may harm us or users of the app or expose them to liability'),
            ),
            SizedBox(height: 20),
            Text(
              'Termination',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We may terminate or suspend your account and bar access to the app immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.',
            ),
            SizedBox(height: 20),
            Text(
              'Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'In no event shall Tracky, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your use or inability to use the app; (ii) any unauthorized access to or use of our servers and/or any personal information stored therein; (iii) any interruption or cessation of transmission to or from the app; (iv) any bugs, viruses, trojan horses, or the like that may be transmitted to or through our app by any third party; (v) any errors or omissions in any content or for any loss or damage incurred as a result of your use of any content posted, emailed, transmitted, or otherwise made available through the app; and/or (vi) any conduct or content of any third party on the app.',
            ),
            SizedBox(height: 20),
            Text(
              'Governing Law',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'These Terms shall be governed and construed in accordance with the laws of your country, without regard to its conflict of law provisions.',
            ),
            SizedBox(height: 20),
            Text(
              'Changes to These Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.',
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions about these Terms, please contact us:',
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
