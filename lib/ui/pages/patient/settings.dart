import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage('')),
            title: Text('Name'),
          ),
          Divider(),
          customListTile(Icons.person, 'Profile'),
          customListTile(Icons.brightness_4, 'Mode'),
          customListTile(Icons.language, 'Language'),
          customListTile(Icons.phone, 'Contact Us'),
          customListTile(Icons.error_outline_outlined, 'About Us'),
          customListTile(Icons.logout, 'Log out'),
        ],
      ),
    );
  }

  customListTile(IconData icon, String title) => Column(
        children: [
          ListTile(
            onTap: () {},
            leading: Icon(
              icon,
              color: CustomColors.blue,
            ),
            title: Text(title),
          ),
          Divider(),
        ],
      );

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
        color: CustomColors.white,
      );
}
