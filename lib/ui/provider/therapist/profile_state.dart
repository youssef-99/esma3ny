import 'dart:async';

import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class TherapistProfileState extends ChangeNotifier {
  // get all profile data
  TherapistRepository _therapistRepository = TherapistRepository();
  PublicRepository _publicRepository = PublicRepository();
  TherapistProfileResponse _therapistProfileResponse;
  List<Specialization> _specializations = [];

  Future<void> getProfileTherapist() async {
    _therapistProfileResponse = await _therapistRepository.getProfile();
    if (await SharedPrefrencesHelper.getSpecializations == null)
      await _publicRepository.getSpcializations();

    _specializations = await SharedPrefrencesHelper.getSpecializations;
  }

  updateProfile() async {
    _therapistProfileResponse = await _therapistRepository.getProfile();
    notifyListeners();
  }

  Future<void> deleteExperience(int id) async {
    await _therapistRepository.deleteExperience(id);
  }

  Future<void> deleteEducation(int id) async {
    await _therapistRepository.deleteEducation(id);
  }

  Future<void> deleteCertificate(int id) async {
    await _therapistRepository.deleteCertificate(id);
  }

  bool showBalance() =>
      _therapistProfileResponse.hasForeignAccount &&
      !_therapistProfileResponse.isStripeActivated;

  update() => notifyListeners();

  TherapistProfileResponse get therapistProfileResponse =>
      _therapistProfileResponse;
  List<Specialization> get specializations => _specializations;
}
