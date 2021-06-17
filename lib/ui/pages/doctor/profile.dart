import 'package:flutter/material.dart';

class TherapistProfilePage extends StatefulWidget {
  @override
  _TherapistProfilePageState createState() => _TherapistProfilePageState();
}

class _TherapistProfilePageState extends State<TherapistProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => ListView(
        children: [
          customListTile(
            Icons.info,
            'Basic Information',
            () => Navigator.pushNamed(context, 'basic_info'),
          ),
          customListTile(Icons.person, 'About Me', () {}),
          customListTile(Icons.sticky_note_2, 'Experience', () {}),
          customListTile(Icons.monetization_on_outlined, 'Fees', () {}),
          customListTile(Icons.history, 'Session History', () {}),
        ],
      );

  customListTile(IconData icon, String title, Function onTap) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => onTap(),
      );
}
