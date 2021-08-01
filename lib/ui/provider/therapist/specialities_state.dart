import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class SpecialitiesState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  List<bool> checkedSpecialization = [];
  List<bool> checkedMainFocus = [];
  bool isInit = false;
  Map<String, dynamic> errors = {};
  bool _loading = false;
  bool _isUpdated = false;

  initValues(
    List<Specialization> specialities,
    List<Specialization> selectedSpecializations,
    List<Specialization> seletedMainFocus,
  ) {
    if (!isInit) {
      for (int i = 0; i < specialities.length; i++) {
        checkedSpecialization.add(false);
        checkedMainFocus.add(false);
      }
      for (Specialization specialization in selectedSpecializations) {
        checkedSpecialization[specialization.id - 1] = true;
      }

      for (Specialization specialization in seletedMainFocus) {
        checkedMainFocus[specialization.id - 1] = true;
      }

      isInit = true;
    }
  }

  setMainFocus(Specialization currentSpecialization, bool value) {
    checkedMainFocus[currentSpecialization.id - 1] = value;
    print(checkedMainFocus[currentSpecialization.id - 1]);
    notifyListeners();
  }

  setSpecialization(Specialization specialization, bool value) {
    checkedSpecialization[specialization.id - 1] = value;
    notifyListeners();
  }

  edit() async {
    List<int> specializations = [];
    List<int> mainFocus = [];
    for (int i = 0; i < checkedSpecialization.length; i++) {
      if (checkedSpecialization[i]) {
        specializations.add(i + 1);
      }
      if (checkedMainFocus[i]) {
        mainFocus.add(i + 1);
      }
    }

    await ExceptionHandling.hanleToastException(() async {
      _loading = true;
      errors = {};
      _isUpdated = false;
      notifyListeners();
      try {
        await _therapistRepository.updateSpeciality(specializations, mainFocus);
        _isUpdated = true;
        notifyListeners();
      } on InvalidData catch (e) {
        errors = e.errors;
        _loading = false;
        notifyListeners();
        throw InvalidData(e.errors);
      }
      _loading = false;
      notifyListeners();
    }, 'Done', true);
  }

  bool get isUpdated => _isUpdated;
  bool get loading => _loading;
}
