import 'package:esma3ny/data/models/client_models/health_profile.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:flutter/material.dart';

class HealthProfileState extends ChangeNotifier {
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  HealthProfileHelper _healthProfileHelper;
  TextEditingController referController = TextEditingController();

  String nationailty;
  String maritalStatus;
  String numberOfChildren;
  String education;
  String degree;
  Map<String, bool> services;
  List<int> _problemsChips = [];
  String problemStartDate;
  bool hasFamilyDiagnosed;
  String notes;

  Future<HealthProfileHelper> getHealthProfileData() async {
    _healthProfileHelper = await _clientRepositoryImpl.getHealthProfileHelper();
    return _healthProfileHelper;
  }

  setProblems(List<int> newProblems) {
    _problemsChips = newProblems;
    notifyListeners();
  }

  List<int> get problems => _problemsChips;
}
