import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicInfoPage extends StatefulWidget {
  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basic Information',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: body(),
          ),
        ),
      ),
    );
  }

  errorHandling(dynamic error) {
    return ErrorIndicator(
      error: error,
      onTryAgain: () => setState(() {}),
    );
  }

  body() => Consumer<TherapistProfileState>(
        builder: (context, state, child) => Container(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 100),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CachedImage(
                url: state.therapistProfileResponse.profileImage.small,
                raduis: 100,
              ),
              SizedBox(height: 10),
              Text(
                state.therapistProfileResponse.name.getLocalizedString(),
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              infoCard(state.therapistProfileResponse),
            ],
          ),
        ),
      );

  infoCard(TherapistProfileResponse therapist) => Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.blue,
            width: 3,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.bottomEnd,
              padding: EdgeInsets.only(top: 5, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'edit_therapist_bais_info');
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    fontFamily: 'arial',
                  ),
                ),
              ),
            ),
            customListTile(Icons.person, therapist.name.getLocalizedString()),
            customListTile(Icons.email, therapist.email),
            customListTile(Icons.phone, therapist.phone),
            customListTile(Icons.person, therapist.gender),
            customListTile(Icons.date_range, therapist.dateOfBirth),
            FutureBuilder(
                future: SharedPrefrencesHelper.getCountryName(
                    int.parse(therapist.countryId)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                    return customListTile(Icons.location_city, snapshot.data);
                  }
                  return SizedBox();
                }),
          ],
        ),
      );

  customListTile(IconData icon, String title) =>
      ListTile(leading: Icon(icon), title: Text(title));
}
