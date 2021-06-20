import 'dart:async';

import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class TherapistProfileState extends ChangeNotifier {
  // get all profile data
  TherapistRepository _therapistRepository = TherapistRepository();
  TherapistProfileResponse _therapistProfileResponse;

  Future<void> getProfileTherapist() async {
    _therapistProfileResponse = await _therapistRepository.getProfile();
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

  update() => notifyListeners();

  TherapistProfileResponse get therapistProfileResponse =>
      _therapistProfileResponse;
}
