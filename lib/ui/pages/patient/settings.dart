import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/language_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
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
          FutureBuilder<LoginResponse>(
            future: SharedPrefrencesHelper.getLoginData(),
            builder: (context, snapshot) => snapshot.hasData
                ? ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data.profileImage.small),
                    ),
                    title: Text(snapshot.data.name),
                    subtitle: Text(snapshot.data.email),
                  )
                : SizedBox(),
          ),
          Divider(),
          customListTile(Icons.person, 'Profile',
              () => Navigator.pushNamed(context, 'client_profile'), null),
          Consumer<CustomThemes>(
              builder: (context, state, child) => customListTile(
                    Icons.brightness_4,
                    'Mode',
                    () async {},
                    Switch(
                      onChanged: (bool value) {
                        state.changeTheme();
                      },
                      value: state.isDark,
                    ),
                  )),
          customListTile(Icons.language, 'Language', () {
            showDialog(
                context: context,
                builder: (context) => Consumer<LanguageState>(
                      builder: (context, state, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              child: CheckboxListTile(
                                title: Text('Arabic'),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                value: state.isArabic,
                                onChanged: (bool val) async {
                                  if (val) {
                                    await state.changeLocale();
                                    Navigator.pop(context);
                                  }
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                            Material(
                              child: CheckboxListTile(
                                title: Text('English'),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                value: state.isEnglish,
                                onChanged: (bool val) async {
                                  if (val) {
                                    await state.changeLocale();
                                    Navigator.pop(context);
                                  }
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          }, null),
          customListTile(Icons.phone, 'Contact Us', () {
            launch('mailto:esma3ny@support.com');
          }, null),
          customListTile(Icons.error_outline_outlined, 'About Us', () {
            launch('https://esma3ny.org/');
          }, null),
          customListTile(Icons.logout, 'Log out', () async {
            _clientRepositoryImpl.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }, null),
        ],
      ),
    );
  }

  customListTile(
          IconData icon, String title, Function onTap, Widget trailing) =>
      Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Icon(
              icon,
              color: CustomColors.blue,
            ),
            title: Text(title),
            trailing: trailing ?? SizedBox(),
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
