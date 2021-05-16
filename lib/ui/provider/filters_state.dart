import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:flutter/material.dart';

class FilterState extends ChangeNotifier {
  Specialization _specialization;
  Language _language;
  Job _job;
  String _gender;
  List<String> genders = ['other', 'male', 'female'];
  int genderIndex = 0;
  bool isFilterd = false;

  reset() {
    _specialization = null;
    _language = null;
    _gender = null;
    genderIndex = 0;
    notifyListeners();
  }

  apply() {
    isFilterd = true;
    notifyListeners();
  }

  setSpecialization(Specialization specialization) =>
      this._specialization = specialization;

  setLanguage(Language language) => this._language = language;

  setJobs(Job job) => this._job = job;

  setGender(int idex) {
    this.genderIndex = idex;
    _gender = genders[genderIndex];
    notifyListeners();
  }

  Specialization get specialization => _specialization;
  Language get language => _language;
  Job get job => _job;
  String get gender => _gender;
}
