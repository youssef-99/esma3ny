import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/data/models/client_models/time_slot_response.dart';
import 'package:esma3ny/ui/provider/upcoming_sessions_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    isStarted = timeSlot.status == 'started';
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
            alignment: Alignment.topRight,
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
                  customListTile(
                      Icons.timer, '${timeSlot.duration} / ${timeSlot.type}'),
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
        child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(timeSlot.doctorProfileImage)),
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
          // TODO: go to therapist profile
          Navigator.pushNamed(context, 'comming_soon');
        },
        child: AutoSizeText(
          timeSlot.doctorNameEn,
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

  bottomSection() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(() {
            print(timeSlot.sessionId);
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content:
                          Text('Are you sure you want to canel this session ?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No')),
                        TextButton(
                            onPressed: () {
                              Provider.of<UpcommingSessionState>(context,
                                      listen: false)
                                  .cancelSession(timeSlot.sessionId);
                              Navigator.pop(context);
                            },
                            child: Text('yes')),
                      ],
                    ));
          }, 'Cancel', CustomColors.orange),
          button(() {}, 'Reschedule', CustomColors.blue),
          button(() {
            if (isStarted) {
              // TODO: go to Session Page
            } else {
              Fluttertoast.showToast(msg: 'Session didn\'t started yet!');
            }
          }, 'Start', isStarted ? Colors.green : CustomColors.grey),
        ],
      );
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
