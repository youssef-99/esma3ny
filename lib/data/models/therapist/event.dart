import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:flutter/material.dart';

class Event extends TimeSlot {
  final String title;

  Event({@required this.title});

  @override
  String toString() => title;
}
