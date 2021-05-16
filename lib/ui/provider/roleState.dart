import 'package:flutter/material.dart';

class RoleState extends ChangeNotifier {
  bool client = true, therapist = false;

  clientPressed() {
    client = true;
    therapist = false;
    notifyListeners();
  }

  therapistPressed() {
    therapist = true;
    client = false;
    notifyListeners();
  }
}
