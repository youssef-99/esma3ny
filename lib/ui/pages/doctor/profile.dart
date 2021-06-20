import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/ui/pages/doctor/about_profile.dart';
import 'package:esma3ny/ui/pages/doctor/basic_info.dart';
import 'package:esma3ny/ui/pages/doctor/experiences.dart';
import 'package:esma3ny/ui/pages/doctor/fees.dart';
import 'package:esma3ny/ui/provider/therapist/basic_info_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  body() => Consumer2<TherapistProfileState, EditBasicInfoState>(
        builder: (context, profileState, basicInfoState, child) =>
            FutureBuilder(
                future: profileState.getProfileTherapist(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CustomProgressIndicator();
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return errorHandling(snapshot.error);
                    }
                    basicInfoState
                        .initTherapist(profileState.therapistProfileResponse);
                    return dataWidget(profileState.therapistProfileResponse);
                  }
                  return SomethingWentWrongWidget();
                }),
      );

  errorHandling(dynamic error) {
    return ErrorIndicator(
      error: error,
      onTryAgain: () => setState(() {}),
    );
  }

  dataWidget(TherapistProfileResponse therapistProfileResponse) =>
      Consumer<TherapistProfileState>(
        builder: (context, state, child) => ListView(
          children: [
            customListTile(
              Icons.info,
              'Basic Information',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BasicInfoPage(),
                ),
              ),
            ),
            customListTile(
              Icons.person,
              'About Me',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AboutMePage(),
                ),
              ),
            ),
            customListTile(
              Icons.sticky_note_2,
              'Experience',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExperiencePage(),
                ),
              ),
            ),
            customListTile(
              Icons.monetization_on_outlined,
              'Fees',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeesPage(),
                ),
              ),
            ),
            customListTile(
              Icons.money,
              'Balance',
              () {},
            ),
            customListTile(
                Icons.history,
                'Session History',
                () =>
                    Navigator.pushNamed(context, 'therapist_session_history')),
          ],
        ),
      );

  customListTile(IconData icon, String title, Function onTap) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios_sharp),
        onTap: () => onTap(),
      );
}
