import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectStripe extends StatelessWidget {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'It looks that you don\'t connect your bank account yet with Esma3ny please complete it before requesting activating your account.',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                await _launchInBrowser('https://esma3ny.org/en/doctor/login');
              },
              child: Text('Connect Now'),
            )
          ],
        ),
      ),
    );
  }
}
