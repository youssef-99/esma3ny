import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/data/models/therapist/appointment.dart';
import 'package:esma3ny/ui/pages/communications/audio.dart';
import 'package:esma3ny/ui/pages/communications/call.dart';
import 'package:esma3ny/ui/pages/communications/chat.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/session_status_mark.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final DateFormat dateFormat = DateFormat.Hm();
  final bool isStarted;

  AppointmentCard(this.appointment, {this.isStarted});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: body(context),
      ),
    );
  }

  body(context) => Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Text(
              '${dateFormat.format(DateTime.parse(appointment.startTime).toLocal())} - ${dateFormat.format(DateTime.parse(appointment.endTime))}',
              style: TextStyle(color: CustomColors.blue),
            ),
          ),
          Row(
            children: [
              clientImage(),
              Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  clientName(),
                  SizedBox(height: 20),
                  customListTile(Icons.timer,
                      '${appointment.duration} ${AppLocalizations.of(context).min} / ${appointment.type}'),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          bottomSection(context),
        ],
      );

  clientImage() => Container(
      margin: EdgeInsets.only(right: 10),
      decoration: decoration(CustomColors.orange, 100),
      child: CachedImage(
        url: appointment.client.image.small,
        raduis: 70,
      ));

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
        color: CustomColors.white,
      );

  clientName() => Container(
        // width: 200,
        child: AutoSizeText(
          appointment.client.name,
          maxLines: 1,
          minFontSize: 12,
          style: TextStyle(
              color: CustomColors.orange, fontWeight: FontWeight.bold),
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

  bottomSection(context) {
    if (appointment.status == SessionStatus.Started ||
        appointment.status == SessionStatus.NotStarted) {
      return Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: checkStarting(context),
      );
    }
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: SessionStatusMark(sessionStatus: appointment.status),
    );
  }

  checkStarting(context) {
    return button(() {
      print(appointment.type == CHAT);
      if (isStarted && appointment.room != null) {
        if (appointment.type == CHAT) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(appointment.room, true,
                      appointment.clientId, appointment.endTime)));
        } else if (appointment.type == VIDEO) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallPage(
                room: appointment.room,
                clientId: appointment.clientId,
                endTime: appointment.endTime,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JoinChannelAudio(
                room: appointment.room,
                clientId: appointment.clientId,
                endTime: appointment.endTime,
              ),
            ),
          );
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
