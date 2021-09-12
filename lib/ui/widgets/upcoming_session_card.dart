import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/client_models/time_slot_response.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/ui/pages/communications/audio.dart';
import 'package:esma3ny/ui/pages/communications/call.dart';
import 'package:esma3ny/ui/pages/communications/chat.dart';
import 'package:esma3ny/ui/pages/patient/therapist_profile_page.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/provider/client/upcoming_sessions_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/payment_sheet.dart';
import 'package:esma3ny/ui/widgets/session_status_mark.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'chached_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpcomingSessionCard extends StatefulWidget {
  final TimeSlotResponse timeSlot;
  UpcomingSessionCard({@required this.timeSlot});
  @override
  _UpcomingSessionCardState createState() => _UpcomingSessionCardState();
}

class _UpcomingSessionCardState extends State<UpcomingSessionCard> {
  TimeSlotResponse get timeSlot => widget.timeSlot;
  DateFormat dateFormat = DateFormat.Hm();
  bool isStarted;

  @override
  void initState() {
    isStarted = timeSlot.status == SessionStatus.Started;
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
              '${dateFormat.format(DateTime.parse(timeSlot.startTime).toLocal())} - ${timeSlot.day}',
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
                  SizedBox(height: 20),
                  customListTile(Icons.timer,
                      '${timeSlot.duration} Min / ${timeSlot.type}'),
                  customListTile(
                      Icons.money, '${timeSlot.amount} / ${timeSlot.currency}'),
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
        child: CachedImage(url: timeSlot.doctorProfileImage.small, raduis: 60),
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
              .setId(timeSlot.doctorId);
          print(timeSlot.doctorId);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TherapistProfile()));
        },
        child: AutoSizeText(
          timeSlot.doctorName.getLocalizedString(),
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

  bottomSection() {
    if (timeSlot.status == SessionStatus.Started ||
        timeSlot.status == SessionStatus.NotStarted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(() {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text(AppLocalizations.of(context)
                          .are_you_sure_you_want_to_cancel_this_session),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context).no)),
                        TextButton(
                            onPressed: () {
                              Provider.of<UpcommingSessionState>(context,
                                      listen: false)
                                  .cancelSession(timeSlot.id);
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context).yes)),
                      ],
                    ));
          }, AppLocalizations.of(context).cancel, CustomColors.orange),
          // button(() {}, 'Reschedule', CustomColors.blue),
          checkforPayment(),
        ],
      );
    }
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: SessionStatusMark(sessionStatus: timeSlot.status),
    );
  }

  checkforPayment() {
    print(timeSlot.paymentStatus);
    if (timeSlot.paymentStatus.length == 0 ||
        timeSlot.paymentStatus == PENDING) {
      return button(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSheet(
              timeSlotId: timeSlot.id,
            ),
          ),
        );
      }, 'Pay Now', CustomColors.orange);
    }
    return button(() {
      if (isStarted && timeSlot.room != null) {
        if (timeSlot.room.type == CHAT) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ChatScreen(timeSlot.room, true, null, timeSlot.endTime)));
        } else if (timeSlot.room.type == VIDEO) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CallPage(
                      room: timeSlot.room, endTime: timeSlot.endTime)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => JoinChannelAudio(
                      room: timeSlot.room, endTime: timeSlot.endTime)));
        }
      } else {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).session_didnt_start_yet);
      }
    }, AppLocalizations.of(context).start,
        isStarted ? Colors.green : CustomColors.grey);
  }

  button(onPressed, String text, Color color) => ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
        ),
      );
}
