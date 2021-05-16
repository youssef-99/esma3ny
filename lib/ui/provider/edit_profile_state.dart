import 'dart:async';

import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileState extends ChangeNotifier {
  ClientModel _client;
  bool _loading = false;
  List<Country> _countries = [];
  Map<String, dynamic> _validationErrors = {};
  Exceptions exception;

  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  // TherapistRepository _therapistRepository = TherapistRepository();
  PublicRepository _publicRepository = PublicRepository();

  _getCountries() async {
    try {
      await _publicRepository.getCountries();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occured check your internet connection',
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
      );
    }
  }

  _fetchCountries() async {
    if (_countries == null) {
      await _getCountries();
    }
    _countries = await SharedPrefrencesHelper.getCountries;
    notifyListeners();
  }

  edit(dynamic user, bool isClient) async {
    _loading = true;
    _validationErrors = {};
    exception = null;
    notifyListeners();

    try {
      // if (isClient)
      await _clientRepositoryImpl.updateProfile(user);
      // else
      //   await _therapistRepository.signup(user);
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

  initClient(ClientModel client) {
    this._client = client;
    // notifyListeners();
  }

  void cleanErrors() {
    _validationErrors.clear();
    notifyListeners();
  }

  ClientModel get client => _client;
  bool get loading => _loading;
  Future<List<Country>> get countries async {
    await _fetchCountries();
    return _countries;
  }

  Map<String, dynamic> get errors => _validationErrors;
}
