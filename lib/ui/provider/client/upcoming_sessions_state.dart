import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:flutter/material.dart';

class UpcommingSessionState extends ChangeNotifier {
  bool _loading = false;
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();

  cancelSession(int id) async {
    _loading = true;
    notifyListeners();
    String msg;

    ExceptionHandling.hanleToastException(() async {
      msg = await _clientRepositoryImpl.cancelSession(id);
    }, msg, true);

    _loading = false;
    notifyListeners();
  }

  reschdule(int oldSessionId, int newSessionId) async {
    _loading = true;
    notifyListeners();

    await _clientRepositoryImpl.rescheduleSession(oldSessionId, newSessionId);

    _loading = false;
    notifyListeners();
  }

  bool get loading => _loading;
}
