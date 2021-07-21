import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class AddEducationState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  Map<String, dynamic> _errors = {};
  bool _isUpdated = false;
  bool _loading = false;

  Future<void> add(Education education) async {
    _loading = true;
    _errors = {};
    _isUpdated = false;
    notifyListeners();

    await ExceptionHandling.hanleToastException(
      () async {
        try {
          await _therapistRepository.addEducation(education);
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
