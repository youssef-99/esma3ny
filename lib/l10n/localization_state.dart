import 'package:flutter/material.dart';

class LocalizationState extends ChangeNotifier {
  bool _isEN = true;

  get currentLocale => _isEN ? Locale('en', '') : Locale('ar', '');

  changeLocale() {
    _isEN = !_isEN;
    notifyListeners();
  }
}
