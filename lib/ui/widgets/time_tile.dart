import 'package:esma3ny/ui/provider/book_session_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeTile extends StatefulWidget {
  final index;
  TimeTile(this.index);
  @override
  _TimeTileState createState() => _TimeTileState();
}

class _TimeTileState extends State<TimeTile> {
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSessionState>(
      builder: (context, state, child) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: state.isPressedTimeSlot[widget.index]
                ? Colors.blue
                : Colors.grey),
        child: Text(
            '${state.selectedTimeSlots[widget.index].startTime} - ${state.selectedTimeSlots[widget.index].endTime}'),
        onPressed: () {
          state.chooseSingleTimeSlot(widget.index);
          state.setSessionPrice();
        },
      ),
    );
  }
}
