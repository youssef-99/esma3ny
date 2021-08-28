import 'package:flutter/foundation.dart';

import 'note_model.dart';

class PrevSessionNotes {
  final List<NoteModel> subjective;
  final List<NoteModel> objective;
  final List<NoteModel> plan;
  final List<NoteModel> assessment;
  final String notes;
  final String publicNotes;

  PrevSessionNotes({
    @required this.subjective,
    @required this.objective,
    @required this.plan,
    @required this.assessment,
    @required this.notes,
    @required this.publicNotes,
  });

  factory PrevSessionNotes.fromjson(Map<String, dynamic> json) {
    List<NoteModel> subjective = [];
    List<NoteModel> objective = [];
    List<NoteModel> plan = [];
    List<NoteModel> assessment = [];

    json['subjective']
        .forEach((element) => subjective.add(NoteModel.fromJson(element)));
    json['objective']
        .forEach((element) => objective.add(NoteModel.fromJson(element)));
    json['assessment']
        .forEach((element) => assessment.add(NoteModel.fromJson(element)));
    json['plan'].forEach((element) => plan.add(NoteModel.fromJson(element)));

    return PrevSessionNotes(
      subjective: subjective,
      objective: objective,
      plan: plan,
      assessment: assessment,
      notes: json['notes'] ?? 'empty',
      publicNotes: json['publicNotes'] ?? 'empty',
    );
  }
}
