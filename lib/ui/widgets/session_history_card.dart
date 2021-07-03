import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/client_models/session_history.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/ui/pages/patient/therapist_profile_page.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/session_status_mark.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionHistoryCard extends StatefulWidget {
  final SessionHistoryModel sessionHistoryModel;
  SessionHistoryCard(this.sessionHistoryModel);

  @override
  _SessionHistoryCardState createState() => _SessionHistoryCardState();
}

class _SessionHistoryCardState extends State<SessionHistoryCard> {
  DateFormat dateFormat = DateFormat.Hm();

  bool isStarted;

  @override
  void initState() {
    isStarted = widget.sessionHistoryModel.status == STARTED;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: body(),
      ),
    );
  }

  body() => Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Text(
              '${dateFormat.format(DateTime.parse(widget.sessionHistoryModel.startTime).toLocal())} - ${widget.sessionHistoryModel.day}',
              style: TextStyle(color: CustomColors.blue),
            ),
          ),
          Row(
            children: [
              therapistImage(),
              Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  therapistName(),
                  AutoSizeText(
                    widget.sessionHistoryModel.doctor.title
                        .getLocalizedString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 20),
                  customListTile(Icons.timer,
                      '${widget.sessionHistoryModel.duration} Min / ${widget.sessionHistoryModel.type}'),
                  // customListTile(
                  //     Icons.money, '${timeSlot.amount} / ${timeSlot.currency}'),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          bottomSection(),
        ],
      );

  therapistImage() => Container(
        margin: EdgeInsets.only(right: 10),
        decoration: decoration(CustomColors.orange, 100),
        child: ClipOval(
          child: Image.network(
            widget.sessionHistoryModel.doctor.profileImage.small,
            width: 130,
            height: 130,
            fit: BoxFit.fill,
          ),
        ),
      );

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
        color: CustomColors.white,
      );

  therapistName() => InkWell(
        onTap: () {
          Provider.of<ClientTherapistProfileState>(context, listen: false)
              .setId(widget.sessionHistoryModel.doctor.id);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TherapistProfile()));
        },
        child: AutoSizeText(
          widget.sessionHistoryModel.doctor.name.getLocalizedString(),
          maxLines: 1,
          style: TextStyle(color: CustomColors.orange, fontSize: 20),
        ),
      );

  customListTile(IconData icon, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  bottomSection() => Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: SessionStatusMark(
          sessionStatus: widget.sessionHistoryModel.status == STARTED
              ? SessionStatus.Finished
              : SessionStatus.Cancelled,
        ),
      );
}
