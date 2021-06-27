import 'dart:collection';

import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:esma3ny/data/models/therapist/new_time_slote.dart';
import 'package:esma3ny/data/models/therapist/time_slote.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  List<TimeSlot> _selectedEvents = [];
  DateFormat _format = DateFormat('yyyy-MM-dd');
  static Map<DateTime, List<TimeSlot>> _eventSource = {};
  bool _loading = true;
  Map<DateTime, List<TimeSlot>> _kEvents;
  bool _isDeletePressed = false;
  bool _isBulk = false;
  String _duration;
  bool _isCreating = false;
  Map<String, dynamic> errors = {};

  final kNow = DateTime.now();
  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 12, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 12, DateTime.now().day);

  setInitEvents() {
    _selectedEvents = getEventsForDay(_focusedDay);
  }

  Future<void> getAllTimeSlots() async {
    _loading = true;

    TherapistTimeSlot therapistTimeSlot =
        await _therapistRepository.getAllTimeSlots(
      _format.format(DateTime.now()),
      _format.format(
        DateTime.now().add(
          Duration(days: 365),
        ),
      ),
    );
    _eventSource = therapistTimeSlot.timeSlots;

    _setEventsMap();
    setInitEvents();

    _loading = false;
    notifyListeners();
  }

  Future<void> deleteSession(int id, int index) async {
    bool isDone = false;
    _isDeletePressed = true;
    notifyListeners();
    await ExceptionHandling.hanleToastException(() async {
      await _therapistRepository.deleteTimeSlot(id);
      isDone = true;
    }, 'Time slot deleted Successfully', true);
    if (isDone) {
      _kEvents[_focusedDay].removeAt(index);
    }
    _isDeletePressed = false;
    notifyListeners();
  }

  Future<bool> createNewTimeSlot({
    @required String startDay,
    @required String startTime,
    @required String endDay,
  }) async {
    bool isDone = false;
    _isCreating = true;
    errors.clear();
    notifyListeners();

    NewTimeSlot newTimeSlot = NewTimeSlot(
      startDay: startDay,
      startTime: startTime,
      endDay: endDay,
      duration: _duration,
    );
    await ExceptionHandling.hanleToastException(
      () async {
        try {
          await _therapistRepository.createTimeSlots(newTimeSlot);
        } on InvalidData catch (e) {
          errors = e.errors;
          notifyListeners();
          throw InvalidData(errors, msg: e.msg);
        }
        isDone = true;
      },
      'Created Successfully',
      true,
    );
    _isCreating = false;
    notifyListeners();

    if (isDone) await getAllTimeSlots();
    return isDone;
  }

  _setEventsMap() {
    _kEvents = LinkedHashMap<DateTime, List<TimeSlot>>(
      equals: isSameDay,
      hashCode: (DateTime key) {
        return key.day * 1000000 + key.month * 10000 + key.year;
      },
    )..addAll(_eventSource);
  }

  List<TimeSlot> getEventsForDay(DateTime day) {
    return _kEvents[day] ?? [];
  }

  changeFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  changeFocusDay(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null; // Important to clean those
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
      notifyListeners();

      _selectedEvents = getEventsForDay(selectedDay);
    }
  }

  // for load data agian when detroy state class
  setLoading() => _loading = true;

  setIsBulk(bool value) {
    _isBulk = value;
    notifyListeners();
  }

  setDuration(String duration) => _duration = duration;

  CalendarFormat get calendarFormat => _calendarFormat;
  RangeSelectionMode get rangeSelectionMode =>
      _rangeSelectionMode; // Can be toggled on/off by longpressing a date
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  DateTime get rangeStart => _rangeStart;
  DateTime get rangeEnd => _rangeEnd;
  List<TimeSlot> get selectedEvents => _selectedEvents;
  bool get loading => _loading;
  bool get isDeletePressed => _isDeletePressed;
  bool get isBulk => _isBulk;
  bool get isCreating => _isCreating;
}
