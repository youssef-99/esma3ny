import 'package:esma3ny/data/models/public/language.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AbouTherapist extends StatelessWidget {
  final Therapist therapist;
  AbouTherapist(
    this.therapist,
  );

  mianFocusString(List<Specialization> specializations) {
    String main = '';
    specializations.forEach((element) {
      main += ', ${element.name.getLocalizedString()}';
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
            future: Provider.of<ClientTherapistProfileState>(context)
                .getCounry(therapist.countryId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return customListTile(Icons.location_city,
                    AppLocalizations.of(context).region, snapshot.data);

              return SizedBox();
            },
          ),
          customListTile(Icons.search, AppLocalizations.of(context).main_focus,
              mianFocusString(therapist.mainFocus)),
          customListTile(
            Icons.star,
            AppLocalizations.of(context).specialized_in,
            mianFocusString(therapist.specializations),
          ),
          customListTile(
            Icons.timer_rounded,
            AppLocalizations.of(context).joining_date,
            therapist.joiningDate,
          ),
          ListTile(
            leading: Icon(
              Icons.language,
              color: CustomColors.orange,
            ),
            title: Text(AppLocalizations.of(context).languages),
            subtitle: language(),
          ),
          customListTile(Icons.person, AppLocalizations.of(context).bio,
              therapist.biography.getLocalizedString())
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

  language() {
    List<String> langs = [];
    for (Language lang in therapist.languages) {
      langs.add(lang.name.getLocalizedString());
    }
    String strLang = langs.toString();
    return SizedBox(
        height: 50, child: Text(strLang.substring(1, strLang.length - 1)));
  }
}
