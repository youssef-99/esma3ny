import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/therapist/about_therapist.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';

class AboutMeState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  PublicRepository _publicRepository = PublicRepository();
  List<String> _prefix = ['Dr', 'PsyD', 'Prof', 'MBPsS', 'Mr', 'Mrs', 'Ms'];
  Map<String, dynamic> _errors = {};
  bool _isUpdated = false;
  bool _loading = false;
  List<Language> _languages = [];
  List<int> _languagesTags = [];
  List<int> _selectedTags = [];
  List<Job> jobs = [];

  Future<void> getJobs() async {
    if (SharedPrefrencesHelper.job == null) await _publicRepository.getJob();
    jobs = await SharedPrefrencesHelper.job;
  }

  Future<void> getLanguages(List<Language> selectedLanguages) async {
    if (SharedPrefrencesHelper.getLanguages == null)
      await _publicRepository.getLanguages();
    _languages = await SharedPrefrencesHelper.getLanguages;
    notifyListeners();
    _languagesTags = [];
    for (Language tag in languages) {
      _languagesTags.add(tag.id);
    }

    _selectedTags = [];
    for (Language language in selectedLanguages) {
      _selectedTags.add(language.id);
    }
  }

  Future<void> edit(AboutTherapistModel aboutTherapistModel) async {
    _loading = true;
    _errors = {};
    _isUpdated = false;
    notifyListeners();

    await ExceptionHandling.hanleToastException(
      () async {
        try {
          await _therapistRepository.updateAboutProfile(aboutTherapistModel);
          _isUpdated = true;
          notifyListeners();
        } on InvalidData catch (e) {
          _errors = e.errors;
          notifyListeners();
          throw InvalidData(_errors);
        }
      },
      'Updated Successfully',
      true,
    );
    _loading = false;
    notifyListeners();
  }

  setLanguages(List<int> selectedLanguages) {
    _selectedTags = selectedLanguages;
    notifyListeners();
  }

  List<String> get prefixes => _prefix;
  Map<String, dynamic> get errors => _errors;
  bool get isUpdated => _isUpdated;
  bool get loading => _loading;
  List<Language> get languages => _languages;
  List<int> get languagesTag => _languagesTags;
  List<int> get selectedLanguage => _selectedTags;
}
