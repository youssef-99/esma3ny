import 'package:meta/meta.dart';

class Job {
  final id;
  final nameEn;
  final nameAr;

  Job({@required this.id, @required this.nameEn, @required this.nameAr});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
