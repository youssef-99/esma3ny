import 'package:meta/meta.dart';

class FilterTherapist {
  final specializeId;
  final languageId;
  final jobId;
  final gender;

  FilterTherapist({
    @required this.specializeId,
    @required this.languageId,
    @required this.jobId,
    @required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'specialize': specializeId,
      'language': languageId,
      'job': jobId,
      'gender': gender,
    };
  }
}
