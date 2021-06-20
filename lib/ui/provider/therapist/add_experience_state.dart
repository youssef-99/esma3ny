import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class AddExperienceState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  Map<String, dynamic> _errors = {};
  bool _isUpdated = false;
  bool _loading = false;

  Future<void> add(Experience experience) async {
    _loading = true;
    _errors = {};
    _isUpdated = false;
    notifyListeners();

    await ExceptionHandling.hanleToastException(
      () async {
        try {
          await _therapistRepository.addExperience(experience);
          _isUpdated = true;
          notifyListeners();
        } on InvalidData catch (e) {
          _errors = e.errors;
          notifyListeners();
          throw InvalidData(_errors);
        }
      },
      'Experience Added Successfully',
      true,
    );
    _loading = false;
    notifyListeners();
  }

  Map<String, dynamic> get errors => _errors;
  bool get isUpdated => _isUpdated;
  bool get loading => _loading;
}
