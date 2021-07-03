import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class AboutMePage extends StatefulWidget {
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
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, 'edit_about_me_page'),
              child: Text('Edit')),
        ],
      ),
      body: body(),
    );
  }

  body() => Consumer<TherapistProfileState>(
        builder: (context, state, child) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<Job>>(
                  future: SharedPrefrencesHelper.job,
                  builder: (context, snapshot) => snapshot.hasData
                      ? customListTile(
                          Icons.work,
                          snapshot
                              .data[state.therapistProfileResponse.jobId - 1]
                              .name
                              .getLocalizedString(),
                          () {})
                      : SizedBox()),
              customListTile(Icons.work,
                  state.therapistProfileResponse.title.stringEn, () {}),
              customListTile(Icons.work,
                  state.therapistProfileResponse.title.stringAr, () {}),
              customListTile(
                  Icons.person, state.therapistProfileResponse.prefix, () {}),
              // customListTile(Icons.language, state.therapistProfileResponse., (){}),
              customListTile(Icons.menu_book_sharp,
                  state.therapistProfileResponse.biography.stringEn, () {}),
              customListTile(Icons.menu_book_sharp,
                  state.therapistProfileResponse.biography.stringAr, () {}),
              languages(state.therapistProfileResponse.languages),
            ],
          ),
        ),
      );

  customListTile(IconData icon, String title, Function onTap) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => onTap(),
      );

  languages(List<Language> languages) => S2ChipsTile(
      leading: Icon(Icons.public),
      values: languages
          .map(
            (language) => S2Choice(
              value: language.id,
              title: language.name.getLocalizedString(),
            ),
          )
          .toList(),
      onTap: () {},
      title: Text('Languages'));
}
