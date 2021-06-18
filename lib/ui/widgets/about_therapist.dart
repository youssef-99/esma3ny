import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';

class AbouTherapist extends StatelessWidget {
  final Therapist therapist;
  AbouTherapist(
    this.therapist,
  );

  mianFocusString(List<Specialization> specializations) {
    String main = '';
    specializations.forEach((element) {
      main += ', ${element.nameEn}';
    });
    return main.isNotEmpty ? main.substring(2) : main;
  }

  final DateFormat dateFormat = DateFormat('dd - MM - yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: mainInfo(context),
      ),
    );
  }

  mainInfo(context) => Column(
        children: [
          FutureBuilder(
            future: Provider.of<TherapistProfileState>(context)
                .getCounry(int.parse(therapist.countryId)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return customListTile(
                    Icons.location_city, 'Region', snapshot.data);

              return SizedBox();
            },
          ),
          customListTile(
              Icons.search, 'Main Focus', mianFocusString(therapist.mainFocus)),
          customListTile(Icons.star, 'Specialized in',
              mianFocusString(therapist.specializations)),
          customListTile(Icons.timer_rounded, 'Joining Date',
              dateFormat.format(DateTime.parse(therapist.joiningDate))),
          ListTile(
            leading: Icon(
              Icons.language,
              color: CustomColors.orange,
            ),
            title: Text('Language'),
            subtitle: language(),
          ),
          customListTile(Icons.person, 'Bio', therapist.biographyEn)
        ],
      );

  customListTile(IconData icon, String title, String subTitle) => ListTile(
        leading: Icon(
          icon,
          color: CustomColors.orange,
        ),
        title: Text(title),
        subtitle: Text(subTitle),
      );

  language() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('arabic'),
          Text('english'),
          Text('italy'),
        ],
      );
}
