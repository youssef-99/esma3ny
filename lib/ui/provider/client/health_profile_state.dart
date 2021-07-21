import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/client_models/health_profile.dart';
import 'package:esma3ny/data/models/client_models/health_profile_helper.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HealthProfileState extends ChangeNotifier {
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  PublicRepository _publicRepository = PublicRepository();
  HealthProfileHelper _healthProfileHelper;
  TextEditingController referController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController relation = TextEditingController();
  TextEditingController problemStartedAt = TextEditingController();
  TextEditingController notes = TextEditingController();
  List<TextEditingController> familyProblemNotes = [];
  HealthProfileJson _healthProfileJson;

  bool _isMe = false;
  bool isDone = false;
  List<bool> services = [];
  int countryId;
  String maritalStatus;
  int numberOfChildren;
  String education;
  String degree;
  List<int> _problemsChips = [];
  bool isFamilyProblem = false;
  List<String> genderOptions = ['Male', 'Female'];
  String selectedGender = 'male';
  List<Specialization> specializations = [];
  List<bool> specializationSelections = [];

  Future<HealthProfileHelper> getHealthProfileData() async {
    _healthProfileHelper = await _clientRepositoryImpl.getHealthProfileHelper();
    services =
        List.generate(_healthProfileHelper.services.length, (index) => false);

    if (await SharedPrefrencesHelper.getSpecializations == null) {
      await _publicRepository.getSpcializations();
    }
    specializations = await SharedPrefrencesHelper.getSpecializations;
    specializationSelections =
        List.generate(specializations.length, (index) => false);

    familyProblemNotes = List.generate(
        specializations.length, (index) => TextEditingController());
    return _healthProfileHelper;
  }

  setProblems(List<int> newProblems) {
    _problemsChips = newProblems;
    notifyListeners();
  }

  addService(int idx) {
    services[idx] = !services[idx];
    notifyListeners();
  }

  addSpecialization(int idx) {
    specializationSelections[idx] = !specializationSelections[idx];
    notifyListeners();
  }

  changeForME() {
    _isMe = !isMe;
    notifyListeners();
  }

  isFamilyProblemPressed() {
    isFamilyProblem = !isFamilyProblem;
    notifyListeners();
  }

  _makeHealthProfile() {
    Map<String, String> services = {};
    for (int i = 0; i < _healthProfileHelper.services.length; i++) {
      services[_healthProfileHelper.services[i].key] =
          this.services[i].toString();
    }

    List<String> problems = [];
    for (int i = 0; i < this.problems.length; i++) {
      problems.add(_healthProfileHelper.problems[this.problems[i]].key);
    }

    Map<int, String> familyProblem = {};
    List<String> familyNotes = [];

    for (int i = 1; i <= specializationSelections.length; i++) {
      familyProblem[i] = specializationSelections[i - 1].toString();
      if (familyProblemNotes[i - 1].text.isNotEmpty)
        familyNotes.add(familyProblemNotes[i - 1].text);
    }

    Map<String, dynamic> allFamilyProblems = {
      'problems': familyProblem,
      'notes': familyNotes,
    };

    _healthProfileJson = HealthProfileJson(
      forMe: (!_isMe).toString(),
      name: name.text,
      gender: selectedGender,
      dateOfBirth: dateOfBirth.text,
      relation: relation.text,
      refer: referController.text,
      nationalityId: countryId,
      maritalStatus: maritalStatus,
      children: numberOfChildren,
      education: Education(type: education, degree: degree),
      services: services,
      problems: problems,
      problemStartedAt: problemStartedAt.text,
      hasFamilyDiagnosed: isFamilyProblem.toString(),
      familyProblem: allFamilyProblems,
      note: notes.text,
    );
  }

  submitHealthProfile() async {
    _makeHealthProfile();
    print(_healthProfileJson.tojson());
    isDone = false;
    String doneMessage = '';
    await ExceptionHandling.hanleToastException(
      () async {
        doneMessage =
            await _clientRepositoryImpl.updateHealthProfile(_healthProfileJson);
        Fluttertoast.showToast(msg: doneMessage);
        isDone = true;
      },
      doneMessage,
      false,
    );
  }

  List<int> get problems => _problemsChips;
  bool get isMe => _isMe;
}
