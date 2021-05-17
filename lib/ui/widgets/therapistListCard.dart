import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_general_info.dart';
import 'package:esma3ny/ui/provider/therapist_profile_state.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';

class TherapistListCard extends StatefulWidget {
  final TherapistListInfo therapist;
  TherapistListCard(this.therapist);
  @override
  _TherapistListCardState createState() => _TherapistListCardState();
}

class _TherapistListCardState extends State<TherapistListCard> {
  TherapistListInfo get _therapist => widget.therapist;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 25, left: 10),
      decoration: decoration(CustomColors.blue, 60),
      child: Row(
        children: [
          therapistImage(),
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
        color: CustomColors.white,
      );

  therapistImage() => Container(
        margin: EdgeInsets.only(right: 10),
        decoration: decoration(CustomColors.orange, 100),
        child: CircleAvatar(
          radius: 60,
          // backgroundImage: NetworkImage(_therapist.profileImage),
        ),
      );

  therapistName() => AutoSizeText(
        _therapist.nameEn,
        maxLines: 1,
        style: TextStyle(color: CustomColors.orange, fontSize: 20),
      );

  jobTitle() => Text(
        _therapist.job == null ? 'Unknown' : _therapist.job.nameEn,
        style: Theme.of(context).textTheme.caption,
      );

  specialization() => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            TextSpan(
              text: 'specialized at: ',
            ),
            TextSpan(
              text: 'Personal disorder and depression',
              style: TextStyle(
                color: CustomColors.blue,
              ),
            ),
          ],
        ),
      );

  bottmSection() => Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<TherapistProfileState>(context, listen: false)
              .setId(_therapist.id);
          Navigator.pushNamed(context, 'therapist_profile');
        },
        child: Text('See more'),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        ),
      ));
}
