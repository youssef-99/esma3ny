import 'dart:async';

import 'package:dio/dio.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {
  bool _showPassword = true;
  Map<String, dynamic> _vlidationErrors = {};
  Exceptions exception;
  bool _loading = false;
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  TherapistRepository _therapistRepository = TherapistRepository();
  bool isVirified;

  changePsswordVisibilty() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  login(String email, String pass, bool isClient) async {
    _vlidationErrors.clear();
    resetException();
    isVirified = true;
    _loading = true;
    notifyListeners();
    try {
      Response response;
      if (isClient) {
        response = await _clientRepositoryImpl.login(email, pass);
        await _clientRepositoryImpl.getProfile();
      } else {
        response = await _therapistRepository.login(email, pass);
        await _therapistRepository.getProfile();
      }
      print(response.data);
    } on InvalidData catch (e) {
      if (e.statusCode == 403) {
        isVirified = false;
      } else {
        _vlidationErrors = e.errors;
        exception = Exceptions.InvalidData;
      }
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
  }

  resetException() {
    exception = null;
  }

  bool get showPassword => _showPassword;
  bool get loading => _loading;
  Map<String, dynamic> get errors => _vlidationErrors;
}
