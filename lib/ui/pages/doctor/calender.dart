import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:esma3ny/ui/provider/therapist/calendar_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/create_time_slote.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  initState() {
    Provider.of<CalendarState>(context, listen: false).setLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarState>(
      builder: (context, state, child) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state.loading,
          widgetBuilder: (context) => FutureBuilder(
            future: state.getAllTimeSlots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return ErrorIndicator(
                  error: snapshot.error,
                  onTryAgain: () => setState(() {}),
                );

              return CustomProgressIndicator();
            },
          ),
          fallbackBuilder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Calendar',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => CreateTimeSlot(),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: CustomColors.orange,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                TableCalendar<TimeSlot>(
                  firstDay: state.kFirstDay,
                  lastDay: state.kLastDay,
                  focusedDay: state.focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(state.selectedDay, day),
                  rangeStartDay: state.rangeStart,
                  rangeEndDay: state.rangeEnd,
                  calendarFormat: state.calendarFormat,
                  rangeSelectionMode: state.rangeSelectionMode,
                  eventLoader: state.getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: state.onDaySelected,
                  onFormatChanged: (format) {
                    if (state.calendarFormat != format) {
                      state.changeFormat(format);
                    }
                  },
                  onPageChanged: (focusedDay) =>
                      state.changeFocusDay(focusedDay),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(5),
                          elevation: 1,
                          child: session(state.selectedEvents[index], index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  session(TimeSlot session, int index) => Consumer<CalendarState>(
        builder: (context, state, child) => ListTile(
          leading: Icon(
            Icons.brightness_1,
            color: session.client == null ? CustomColors.orange : Colors.green,
          ),
          title: session.client == null
              ? Text('Available')
              : Text(
                  '${session.client.name}',
                ),
          subtitle: Text(
              '${session.startTime} - ${session.endTime}   ${session.duration}'),
          trailing: IconButton(
            enableFeedback: false,
            onPressed: state.isDeletePressed
                ? null
                : () {
                    state.deleteSession(session.id, index);
                  },
            icon: Icon(Icons.delete),
          ),
        ),
      );
}
