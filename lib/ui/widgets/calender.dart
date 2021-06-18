import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  DateFormat _format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final _calendarCarouselNoHeader = LayoutBuilder(
      builder: (context, constrains) => Consumer<BookSessionState>(
        builder: (context, state, child) => CalendarCarousel<Event>(
          selectedDayBorderColor: Colors.orange,
          selectedDayButtonColor: Colors.orange,
          daysTextStyle: Theme.of(context).textTheme.subtitle1,
          onDayPressed: (date, events) {
            this.setState(() => _selectedDate = date);
          },
          daysHaveCircularBorder: true,
          showOnlyCurrentMonthDate: true,
          weekendTextStyle: Theme.of(context).textTheme.subtitle1,
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          markedDatesMap: state.markedDateMap,
          // dayPadding: constrains.maxWidth * 0.01,
          height: MediaQuery.of(context).size.height * 0.5,
          selectedDateTime: _selectedDate,
          targetDateTime: _targetDateTime,
          // customGridViewPhysics: NeverScrollableScrollPhysics(),
          markedDateCustomShapeBorder:
              CircleBorder(side: BorderSide(color: Colors.yellow)),
          markedDateCustomTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.orange,
          ),
          showHeader: false,
          todayTextStyle: TextStyle(
            color: Colors.black,
          ),
          markedDateWidget: Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
              color: CustomColors.blue,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          markedDateShowIcon: false,
          markedDateIconMaxShown: 1,
          todayButtonColor: Colors.yellow,
          todayBorderColor: Colors.white,
          selectedDayTextStyle: TextStyle(
            color: Colors.white,
          ),
          minSelectedDate: _currentDate.subtract(Duration(days: 360)),
          maxSelectedDate: _currentDate.add(Duration(days: 360)),
          prevDaysTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.pinkAccent,
          ),
          onCalendarChanged: (DateTime date) {
            _targetDateTime = date;
            _currentMonth = DateFormat.yMMM().format(_targetDateTime);
            state.getNextMonth(_format.format(date));
          },
        ),
      ),
    );

    return Consumer<BookSessionState>(
      builder: (context, state, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    _currentMonth,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  )),
                  TextButton(
                    child: Text('PREV'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                      state.getNextMonth(_format.format(_targetDateTime));
                    },
                  )
                ],
              ),
            ),
            Center(
              child: state.loading
                  ? CircularProgressIndicator()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: _calendarCarouselNoHeader,
                    ),
            ), //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    state.chooseDate(_format.format(_selectedDate));
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
