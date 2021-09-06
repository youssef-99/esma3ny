import 'dart:async';

import 'package:esma3ny/data/models/therapist/client_health_profile.dart';
import 'package:esma3ny/data/models/therapist/note_model.dart';
import 'package:esma3ny/data/models/therapist/note_type.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepository.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CallState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  final clientNotes = new TextEditingController();
  final publicNotes = new TextEditingController();
  ClientHealthProfile _clientHealthProfile;
  String uid = '';
  NoteType _assessment;
  NoteType _plan;
  NoteType _subjective;
  NoteType _objective;
  bool sessionEnded = false;
  PagingController _therapistListController;
  PagingController _clientListController;
  bool isCompelete;
  CountdownTimerController timerController;
  bool authorizeNotesReferral = false;
  Timer _debounce;
  int _debouncetime = 3000;

  List<NoteModel> _selectedAssessment = [];
  List<NoteModel> _selectedPlan = [];
  List<NoteModel> _selectedSubjective = [];
  List<NoteModel> _selectedObjective = [];

  createTimer(DateTime endTime) => timerController = CountdownTimerController(
      endTime: endTime.millisecondsSinceEpoch, onEnd: () {});

  _onClientNotesChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      updateNotes('notes', notes: clientNotes.text);
    });
  }

  _onPublicNotesChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      updateNotes('public_notes', notes: publicNotes.text);
    });
  }

  getInitData(String uid, int clientId) async {
    clientNotes.addListener(_onClientNotesChanged);
    publicNotes.addListener(_onPublicNotesChanged);
    this.uid = uid;
    dynamic notes = await _therapistRepository.getNotes(uid);
    _assessment = NoteType.fromJson(notes['notes']['assessment']);
    _plan = NoteType.fromJson(notes['notes']['plan']);
    _subjective = NoteType.fromJson(notes['notes']['subjective']);
    _objective = NoteType.fromJson(notes['notes']['objective']);

    notes['prescription']['assessment'].forEach((assessment) {
      assessment['type'] = 'assessment';
      _selectedAssessment.add(NoteModel.fromJson(assessment));
    });
    notes['prescription']['objective'].forEach((objective) {
      objective['type'] = 'objective';
      _selectedObjective.add(NoteModel.fromJson(objective));
    });
    notes['prescription']['subjective'].forEach((subjective) {
      subjective['type'] = 'subjective';
      _selectedSubjective.add(NoteModel.fromJson(subjective));
    });
    notes['prescription']['plan'].forEach((plan) {
      plan['type'] = 'plan';
      _selectedPlan.add(NoteModel.fromJson(plan));
    });

    clientNotes.text = notes['prescription']['notes'] ?? '';
    publicNotes.text = notes['prescription']['public_notes'] ?? '';

    isCompelete = notes['prescription']['completed'];

    _clientHealthProfile =
        await _therapistRepository.getHealthProfile(clientId);
  }

  authorizeReferral(value, uid) async {
    await _clientRepositoryImpl.authorizeReferral(value, uid);
    authorizeNotesReferral = value;
    notifyListeners();
  }

  setProfileComplete(bool value) async {
    isCompelete = value;
    updateNotes('completed');
    notifyListeners();
  }

  Future<void> updateNotes(String key,
      {List<NoteModel> updatedNotes, String notes}) async {
    Map<String, dynamic> data = {};
    if (key == 'notes' || key == 'public_notes') {
      data = {
        'key': key,
        'value': notes,
      };
    } else if (key == 'completed') {
      data = {
        'key': key,
        'value': isCompelete,
      };
    } else {
      List<Map<String, dynamic>> notes = [];

      updatedNotes.forEach((note) {
        notes.add(note.toJson());
      });

      data = {
        'key': key,
        'value': notes,
      };
    }

    try {
      await _therapistRepository.updateNotes(uid, data);
      Fluttertoast.showToast(msg: 'Done ✅', backgroundColor: Colors.green);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'sorry, try again', backgroundColor: Colors.red);
      throw e;
    }
  }

  addAssessment(NoteModel assessment) {
    _selectedAssessment.add(assessment);
    updateNotes('assessment', updatedNotes: _selectedAssessment);
  }

  addPlan(NoteModel plan) {
    _selectedPlan.add(plan);
    updateNotes('plan', updatedNotes: _selectedPlan);
  }

  addSubjectives(NoteModel subjectives) {
    _selectedSubjective.add(subjectives);
    updateNotes('subjective', updatedNotes: _selectedSubjective);
  }

  addObjectives(NoteModel objectives) {
    _selectedObjective.add(objectives);
    updateNotes('objective', updatedNotes: _selectedObjective);
  }

  deleteAssessment(int idx) {
    NoteModel obj = _selectedAssessment.removeAt(idx);
    updateNotes('assessment', updatedNotes: _selectedAssessment).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedAssessment.insert(idx, obj);
    });
  }

  deletePlan(int idx) {
    NoteModel obj = _selectedPlan.removeAt(idx);
    updateNotes('plan', updatedNotes: _selectedPlan).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedPlan.insert(idx, obj);
    });
  }

  deleteSubjectives(int idx) {
    print(idx);
    NoteModel obj = _selectedSubjective.removeAt(idx);
    updateNotes('subjective', updatedNotes: _selectedSubjective).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedSubjective.insert(idx, obj);
    });
  }

  deleteObjectives(int idx) {
    print(idx);
    NoteModel obj = _selectedObjective.removeAt(idx);
    updateNotes('objective', updatedNotes: _selectedObjective).then((value) {
      notifyListeners();
    }).catchError((e) {
      _selectedObjective.insert(idx, obj);
    });
  }

  setTherapistPagingController(PagingController pagingController) =>
      this._therapistListController = pagingController;

  setClientPagingController(PagingController pagingController) =>
      this._clientListController = pagingController;

  endSession() async {
    await _therapistRepository.endSession(uid);
    sessionEnded = true;
    Timer(Duration(seconds: 1), () {
      _therapistListController.refresh();
    });
  }

  reloadSessionsList() async {
    sessionEnded = true;
    Timer(Duration(seconds: 1), () {
      _clientListController.refresh();
    });
  }

  NoteType get assessment => _assessment;
  NoteType get plan => _plan;
  NoteType get subjective => _subjective;
  NoteType get objective => _objective;
  List<NoteModel> get selectedAssessments => _selectedAssessment;
  List<NoteModel> get selectedPlans => _selectedPlan;
  List<NoteModel> get selectedSubjectives => _selectedSubjective;
  List<NoteModel> get selectedObjectives => _selectedObjective;
  ClientHealthProfile get clientHealthProfile => _clientHealthProfile;
}
