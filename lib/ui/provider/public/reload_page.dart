import 'package:flutter/material.dart';

class ReloadPageState extends ChangeNotifier {
  void reload() => notifyListeners();
}
