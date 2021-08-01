import 'package:esma3ny/data/models/therapist/client_health_profile.dart';
import 'package:esma3ny/data/models/therapist/note_model.dart';
import 'package:esma3ny/data/models/therapist/note_type.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  ClientHealthProfile _clientHealthProfile;
  String uid = '';
  NoteType _assessment;
  NoteType _plan;
  NoteType _subjective;
  NoteType _objective;

  List<NoteModel> _selectedAssessment = [];
  List<NoteModel> _selectedPlan = [];
  List<NoteModel> _selectedSubjective = [];
  List<NoteModel> _selectedObjective = [];

  getInitData(String uid) async {
    this.uid = uid;
    dynamic notes = await _therapistRepository.getNotes(uid);
    _assessment = NoteType.fromJson(notes['assessment']);
    _plan = NoteType.fromJson(notes['plan']);
    _subjective = NoteType.fromJson(notes['subjective']);
    _objective = NoteType.fromJson(notes['objective']);
    _clientHealthProfile = await _therapistRepository.getHealthProfile(uid);
  }

  Future<void> updateNotes(String key, List<NoteModel> updatedNotes) async {
    List<Map<String, dynamic>> notes = [];

    updatedNotes.forEach((note) {
      notes.add(note.toJson());
    });

    Map<String, dynamic> data = {
      'key': key,
      'value': notes,
    };
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
    updateNotes('assessment', _selectedAssessment);
  }

  addPlan(NoteModel plan) {
    _selectedPlan.add(plan);
    updateNotes('plan', _selectedPlan);
  }

  addSubjectives(NoteModel subjectives) {
    _selectedSubjective.add(subjectives);
    updateNotes('subjective', _selectedSubjective);
  }

  addObjectives(NoteModel objectives) {
    _selectedObjective.add(objectives);
    updateNotes('objective', _selectedObjective);
  }

  deleteAssessment(int idx) {
    NoteModel obj = _selectedAssessment.removeAt(idx);
    updateNotes('assessment', _selectedAssessment).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedAssessment.insert(idx, obj);
    });
  }

  deletePlan(int idx) {
    NoteModel obj = _selectedPlan.removeAt(idx);
    updateNotes('plan', _selectedPlan).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedPlan.insert(idx, obj);
    });
  }

  deleteSubjectives(int idx) {
    NoteModel obj = _selectedSubjective.removeAt(idx);
    updateNotes('subjective', _selectedSubjective).then((value) {
      notifyListeners();
    }).onError((error, stackTrace) {
      _selectedSubjective.insert(idx, obj);
    });
  }

  deleteObjectives(int idx) {
    NoteModel obj = _selectedObjective.removeAt(idx);
    updateNotes('objective', _selectedObjective).then((value) {
      notifyListeners();
    }).catchError((e) {
      _selectedObjective.insert(idx, obj);
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
