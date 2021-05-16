import 'package:flutter/material.dart';

class ErrorsState extends ChangeNotifier {
  bool _invalidData = false;
  bool _netWorkConnection = false;
  bool _serverError = false;
  bool _somethingWentWrong = false;

  updateError() {
    _invalidData = false;
    _netWorkConnection = false;
    _serverError = false;
    _somethingWentWrong = false;
    notifyListeners();
  }

  showInvalidDataError() {
    _invalidData = true;
    notifyListeners();
  }

  showNetworkConnectionError() {
    _netWorkConnection = true;
    notifyListeners();
  }

  showServerError() {
    _serverError = true;
    notifyListeners();
  }

  showSomethingWentWrong() {
    _somethingWentWrong = true;
    notifyListeners();
  }

  bool get invlidDataError => _invalidData;
  bool get networkConnectionError => _netWorkConnection;
  bool get serverError => _serverError;
  bool get somethingWentWrongError => _somethingWentWrong;
}
