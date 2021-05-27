import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/data/models/enums/sessionType.dart';
import 'package:esma3ny/data/models/public/available_time_slot_response.dart';
import 'package:esma3ny/data/models/public/session_price_response.dart';
import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookSessionState extends ChangeNotifier {
  DateFormat format = DateFormat('yyyy-MM-dd');
  PublicRepository _publicRepository = PublicRepository();
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();

  Therapist _therapist;
  List<AvailableTimeSlotResponse> _availableTimeSlots;
  List<TimeSlot> _selectedTimeSlots;
  List<bool> _isPressedTimeSlot = [];
  List<String> _catchedMonths = [];
  String _selectedDate;
  bool _loading = false;
  SessionType _sessionType = SessionType.Video;
  String _sessionTypeText = 'video';
  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
  SessionPriceResponse _sessionPriceResponse;
  TimeSlot _selectedTimeSlot;

  setIsPressedArray(int length) {
    if (_isPressedTimeSlot != null) _isPressedTimeSlot.clear();
    for (int i = 0; i < length; i++) _isPressedTimeSlot.add(false);
    _sessionPriceResponse = null;
    _selectedTimeSlot = null;
  }

  resetValues() {
    _sessionPriceResponse = null;
    _selectedTimeSlot = null;
  }

  setAvailableTimeSlots(List<AvailableTimeSlotResponse> availableTimeSlots) {
    _availableTimeSlots = availableTimeSlots;
    updateCalender();
  }

  setTherapist(Therapist therapist) {
    _therapist = therapist;
    _catchedMonths.clear();
  }

  void getToDaySessions(bool notify) {
    bool isContain = false;
    _availableTimeSlots.forEach((timeSlot) {
      if (format.format(DateTime.now()) == timeSlot.date) {
        isContain = true;
        _selectedTimeSlots = timeSlot.timeSlots;
        setIsPressedArray(_selectedTimeSlots.length);
        _selectedDate = timeSlot.date;
        if (notify) notifyListeners();
        return;
      }
    });

    if (isContain) return;

    _selectedDate = format.format(DateTime.now());
    _selectedTimeSlots = [];
    if (notify) notifyListeners();
  }

  void getTomorrowSessions() {
    _selectedDate = format.format(DateTime.now().add(Duration(days: 1)));

    if (DateTime.now().add(Duration(days: 1)).day == 1) {
      String date = format.format(DateTime.now().add(Duration(days: 1)));
      getNextMonth(date).then((value) {
        initSelectedDate();
      });
    }

    initSelectedDate();
  }

  initSelectedDate() {
    bool isContain = false;
    _availableTimeSlots.forEach((timeSlot) {
      if (_selectedDate == timeSlot.date) {
        isContain = true;
        _selectedTimeSlots = timeSlot.timeSlots;
        setIsPressedArray(_selectedTimeSlots.length);
        notifyListeners();
        return;
      }
    });

    if (isContain) return;

    _selectedTimeSlots = [];
    notifyListeners();
  }

  Future<void> getNextMonth(String date) async {
    _loading = true;
    notifyListeners();

    if (!_catchedMonths.contains(date) &&
        DateTime.parse(date).isAfter(DateTime.now())) {
      _catchedMonths.add(date);
      try {
        _availableTimeSlots.addAll(await _publicRepository
            .showTherapistTimeSlots(_therapist.id, date));
      } catch (_) {
        Fluttertoast.showToast(msg: 'Something Went Wrog');
      }
    }

    _loading = false;
    updateCalender();
    notifyListeners();
  }

  updateCalender() {
    _markedDateMap.clear();
    _availableTimeSlots.forEach((day) {
      List<Event> events = [];
      day.timeSlots.forEach((timeSlot) {
        events.add(
          Event(
            date: DateTime.parse(day.date),
            title: timeSlot.duration,
            id: timeSlot.id,
          ),
        );
      });
      _markedDateMap.addAll(DateTime.parse(day.date), events);
    });
  }

  void chooseDate(String selectedDate) {
    _selectedDate = selectedDate;
    bool isContains = false;
    _availableTimeSlots.forEach((day) {
      if (day.date == selectedDate) {
        isContains = true;
        _selectedTimeSlots = day.timeSlots;
        setIsPressedArray(_selectedTimeSlots.length);
        return;
      }
    });
    if (!isContains) _selectedTimeSlots.clear();
    notifyListeners();
  }

  setSessionType(SessionType sessionType) {
    _sessionType = sessionType;
    if (_sessionType == SessionType.Video)
      _sessionTypeText = 'video';
    else if (_sessionType == SessionType.Audio)
      _sessionTypeText = 'audio';
    else
      _sessionTypeText = 'chat';

    if (_selectedTimeSlot != null) {
      setSessionPrice();
    }
  }

  chooseSingleTimeSlot(int index) {
    for (int i = 0; i < _isPressedTimeSlot.length; i++) {
      if (i == index) {
        _isPressedTimeSlot[i] = true;
        _selectedTimeSlot = _selectedTimeSlots[i];
      } else
        _isPressedTimeSlot[i] = false;
    }
    notifyListeners();
  }

  setSessionPrice() async {
    _sessionPriceResponse = await _clientRepositoryImpl
        .getSelectedTimeSlotPrice(_selectedTimeSlot.id, _sessionTypeText);
    notifyListeners();
  }

  reserveNewSession(bool payLater) async {
    _loading = true;
    notifyListeners();

    await ExceptionHandling.hanleToastException(() async {
      if (payLater) {
        await _clientRepositoryImpl.reserveNewSession(
            selectedTimeSlot.id, _sessionTypeText, payLater, null);
      } else {
        // TODO add stripe token
        await _clientRepositoryImpl.reserveNewSession(
            selectedTimeSlot.id, _sessionTypeText, payLater, null);
      }
    });

    _loading = false;
    notifyListeners();
  }

  List<AvailableTimeSlotResponse> get availableTimeSlots => _availableTimeSlots;
  List<TimeSlot> get selectedTimeSlots => _selectedTimeSlots;
  TimeSlot get selectedTimeSlot => _selectedTimeSlot;
  List<bool> get isPressedTimeSlot => _isPressedTimeSlot;
  String get selectedDate => _selectedDate;
  Therapist get therapist => _therapist;
  bool get loading => _loading;
  EventList<Event> get markedDateMap => _markedDateMap;
  SessionPriceResponse get sessionPriceResponse => _sessionPriceResponse;
  String get sessionTypeText => _sessionTypeText;
}
