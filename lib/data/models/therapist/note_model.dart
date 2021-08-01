import 'package:flutter/foundation.dart';

class NoteModel {
  final int id;
  final String title;
  final String type;

  NoteModel({
    @required this.id,
    @required this.title,
    @required this.type,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
