import 'dart:async';

import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditBasicInfoState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  PublicRepository _publicRepository = PublicRepository();
  List<Country> _countries;
  Therapist _therapist;
  Map<String, dynamic> _validationErrors = {};
  bool _loading = false;
  bool _isUpdated = false;

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
  }

  updateProfileImage(String imagePath) async {
    await ExceptionHandling.hanleToastException(() async {
      await _therapistRepository.uploadProfilePic(imagePath, _therapist);
    }, '', false);
    notifyListeners();
  }

  edit(Therapist user) async {
    _loading = true;
    _validationErrors = {};
    _isUpdated = false;
    notifyListeners();

    try {
      await _therapistRepository.updateBasicInfo(user);
      _isUpdated = true;
    } on InvalidData catch (e) {
      _loading = false;
      _validationErrors = e.errors == null ? {} : e.errors;
    } on NetworkConnectionException catch (_) {
      Fluttertoast.showToast(
          msg: 'Network error check your internet connection');
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'time out try again');
    } on ServerError catch (_) {
      Fluttertoast.showToast(msg: 'Server error try again later');
      notifyListeners();
    } on SomeThingWentWrong catch (_) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }

    _loading = false;
    notifyListeners();
    return user;
  }

  initTherapist(TherapistProfileResponse therapistProfileResponse) {
    Therapist therapist = Therapist(
      name: therapistProfileResponse.nameEn,
      nameAr: therapistProfileResponse.nameAr,
      email: therapistProfileResponse.email,
      phone: therapistProfileResponse.phone,
      gender: therapistProfileResponse.gender,
      dateOfBirth: therapistProfileResponse.dateOfBirth,
      countryId: therapistProfileResponse.countryId,
    );
    this._therapist = therapist;
  }

  void cleanErrors() {
    _validationErrors.clear();
    notifyListeners();
  }

  Future<List<Country>> get countries async {
    await _fetchCountries();
    return _countries;
  }

  bool get loading => _loading;
  bool get isupdated => _isUpdated;
  Map<String, dynamic> get errors => _validationErrors;
}
