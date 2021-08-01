import 'package:esma3ny/data/models/public/job.dart';
import 'package:flutter/foundation.dart';

import 'note_model.dart';

class NoteType {
  final List<NoteModel> notes;

  NoteType({
    @required this.notes,
  });

  factory NoteType.fromJson(List<dynamic> json) {
    List<NoteModel> notes = [];

    json.forEach((element) => notes.add(NoteModel.fromJson(element)));

    return NoteType(notes: notes);
  }
}
