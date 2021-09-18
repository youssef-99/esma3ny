import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_general_info.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TherapistListCard extends StatefulWidget {
  final TherapistListInfo therapist;
  TherapistListCard(this.therapist);
  @override
  _TherapistListCardState createState() => _TherapistListCardState();
}

class _TherapistListCardState extends State<TherapistListCard> {
  TherapistListInfo get _therapist => widget.therapist;
  String mainFocus = '';
  @override
  void initState() {
    _therapist.mainFocus.forEach((mainFocus) {
      this.mainFocus += mainFocus.name.getLocalizedString();
      this.mainFocus += _therapist.mainFocus.last == mainFocus ? "" : ", ";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: decoration(
        CustomColors.blue,
        60,
      ),
      child: Row(
        children: [
          therapistImage(),
          SizedBox(width: 5),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                therapistName(),
                jobTitle(),
                specialization(),
                bottmSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
      );

  therapistImage() => Container(
        decoration: decoration(CustomColors.orange, 100),
        child: CachedImage(
          url: _therapist.profileImage.small,
          raduis: 70,
        ),
      );

  therapistName() => AutoSizeText(
        _therapist.name.getLocalizedString(),
        maxLines: 1,
        style: TextStyle(color: CustomColors.orange, fontSize: 20),
      );

  jobTitle() => Text(
        _therapist.job == null
            ? AppLocalizations.of(context).unknown
            : _therapist.job.name.getLocalizedString(),
        style: Theme.of(context).textTheme.caption,
      );

  specialization() => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.of(context).specialized_at,
            ),
            TextSpan(
              text: mainFocus,
              style: TextStyle(
                color: CustomColors.blue,
              ),
            ),
          ],
        ),
      );

  bottmSection() => Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<ClientTherapistProfileState>(context, listen: false)
              .setId(_therapist.id);
          Navigator.pushNamed(context, 'therapist_profile');
        },
        child: Text(AppLocalizations.of(context).see_more),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        ),
      ));
}
