import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:flutter/material.dart';

class AboutMePage extends StatefulWidget {
  final TherapistProfileResponse therapistProfileResponse;

  const AboutMePage({Key key, @required this.therapistProfileResponse})
      : super(key: key);
  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Me',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(onPressed: () {}, child: Text('Edit')),
        ],
      ),
      body: body(),
    );
  }

  body() => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customListTile(
                Icons.work, widget.therapistProfileResponse.titleEn, () {}),
            customListTile(
                Icons.work, widget.therapistProfileResponse.titleAr, () {}),
            customListTile(
                Icons.person, widget.therapistProfileResponse.prefix, () {}),
            // customListTile(Icons.language, widget.therapistProfileResponse., (){}),
            customListTile(Icons.menu_book_sharp,
                widget.therapistProfileResponse.biographyEn, () {}),
            customListTile(Icons.menu_book_sharp,
                widget.therapistProfileResponse.biographyAr, () {}),
          ],
        ),
      );

  customListTile(IconData icon, String title, Function onTap) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => onTap(),
      );
}
