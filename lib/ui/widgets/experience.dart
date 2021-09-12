import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Experience extends StatelessWidget {
  final Therapist therapist;
  Experience(this.therapist);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: layout(AppLocalizations.of(context).experience, context),
      ),
    );
  }

  layout(String title, context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: listing(),
          )
        ],
      );

  List<Widget> listing() => therapist.experience
      .map(
        (e) => customListTile(
          e.title.getLocalizedString(),
          e.from,
          e.to,
          e.name.getLocalizedString(),
        ),
      )
      .toList();

  Widget customListTile(
          String title, String from, String to, String subTitle) =>
      ListTile(
        leading: Icon(Icons.brightness_1_outlined),
        title: Text(title),
        trailing: Text(
          '$from - $to',
          style: TextStyle(color: CustomColors.blue),
        ),
        subtitle: Text(subTitle),
      );
}
