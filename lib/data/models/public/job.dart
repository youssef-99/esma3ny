import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:meta/meta.dart';

class Job {
  final id;
  final LocaleString name;

  Job({@required this.id, @required this.name});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
