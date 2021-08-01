import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SessionStatusMark extends StatelessWidget {
  final SessionStatus sessionStatus;
  String status;
  SessionStatusMark({@required this.sessionStatus});
  Color color;
  @override
  Widget build(BuildContext context) {
    switch (sessionStatus) {
      case SessionStatus.NotStarted:
        color = Colors.grey;
        status = NOT_STARTED;
        break;
      case SessionStatus.Started:
        color = Colors.green;
        status = STARTED;
        break;
      case SessionStatus.Finished:
        color = Colors.green;
        status = FINIDHED;
        break;
      case SessionStatus.Cancelled:
        color = Colors.red;
        status = CANCELLED;
        break;
      case SessionStatus.Available:
        color = Colors.green;
        status = AVAILABLE;
        break;
    }
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      child: Text(
        status,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
