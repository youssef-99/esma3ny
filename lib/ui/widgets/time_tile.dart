import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:esma3ny/ui/provider/book_session_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeTile extends StatefulWidget {
  final TimeSlot timeSlot;
  final bool isPressed;
  final index;
  TimeTile(this.timeSlot, this.isPressed, this.index);
  @override
  _TimeTileState createState() => _TimeTileState();
}

class _TimeTileState extends State<TimeTile> {
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: widget.isPressed ? Colors.blue : Colors.grey),
      child: Text(widget.timeSlot.startTime),
      onPressed: () {
        Provider.of<BookSessionState>(context)
            .chooseSingleTimeSlot(widget.index);
      },
    );
  }
}
