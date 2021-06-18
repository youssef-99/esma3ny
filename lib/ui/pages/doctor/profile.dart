import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/pages/doctor/about_profile.dart';
import 'package:esma3ny/ui/pages/doctor/basic_info.dart';
import 'package:esma3ny/ui/pages/doctor/experiences.dart';
import 'package:esma3ny/ui/pages/doctor/fees.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';

class TherapistProfilePage extends StatefulWidget {
  @override
  _TherapistProfilePageState createState() => _TherapistProfilePageState();
}

class _TherapistProfilePageState extends State<TherapistProfilePage> {
  TherapistRepository _therapistRepository = TherapistRepository();
  Future<TherapistProfileResponse> get _getTherapist =>
      _therapistRepository.getProfile();

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

  body() => FutureBuilder<TherapistProfileResponse>(
      future: _getTherapist,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CustomProgressIndicator();
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
          if (snapshot.hasData) {
            // state.initClient(snapshot.data);
            return dataWidget(snapshot.data);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            // return errorHandling(snapShot.error);
          }
        }
        return SomethingWentWrongWidget();
      });

  dataWidget(TherapistProfileResponse therapistProfileResponse) => ListView(
        children: [
          customListTile(
            Icons.info,
            'Basic Information',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BasicInfoPage(
                  therapistProfileResponse: therapistProfileResponse,
                ),
              ),
            ),
          ),
          customListTile(
            Icons.person,
            'About Me',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutMePage(
                  therapistProfileResponse: therapistProfileResponse,
                ),
              ),
            ),
          ),
          customListTile(
            Icons.sticky_note_2,
            'Experience',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExperiencePage(
                  therapistProfileResponse: therapistProfileResponse,
                ),
              ),
            ),
          ),
          customListTile(
            Icons.monetization_on_outlined,
            'Fees',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FeesPage(
                  fees: therapistProfileResponse.fees,
                ),
              ),
            ),
          ),
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
