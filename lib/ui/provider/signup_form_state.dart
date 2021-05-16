import 'dart:async';

import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class SignupState extends ChangeNotifier {
  bool _loading = false;
  Map<String, dynamic> _validationErrors = {};
  Exceptions exception;

  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  TherapistRepository _therapistRepository = TherapistRepository();

  signup(dynamic user, bool isClient) async {
    _loading = true;
    _validationErrors = {};
    exception = null;
    notifyListeners();

    try {
      if (isClient)
        await _clientRepositoryImpl.signup(user);
      else
        await _therapistRepository.signup(user);
    } on InvalidData catch (e) {
      _loading = false;
      _validationErrors = e.errors;
      exception = Exceptions.InvalidData;
      notifyListeners();
    } on NetworkConnectionException catch (_) {
      exception = Exceptions.NetworkError;
      notifyListeners();
    } on TimeoutException catch (_) {
      exception = Exceptions.Timeout;
      notifyListeners();
    } on ServerError catch (_) {
      exception = Exceptions.ServerError;
      notifyListeners();
    } on SomeThingWentWrong catch (_) {
      exception = Exceptions.SomethingWentWrong;
      notifyListeners();
    }

    _loading = false;
    notifyListeners();
    return user;
  }

  void cleanErrors() {
    _validationErrors.clear();
    notifyListeners();
  }

  bool get loading => _loading;
  Map<String, dynamic> get errors => _validationErrors;
}
