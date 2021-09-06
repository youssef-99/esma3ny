import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/data/models/public/specialization.dart';

class TherapistListInfo {
  final id;
  final LocaleString name;
  final jobId;
  final ProfileImage profileImage;
  final Job job;
  final List<Specialization> mainFocus;

  TherapistListInfo({
    this.id,
    this.name,
    this.job,
    this.jobId,
    this.profileImage,
    this.mainFocus,
  });

  factory TherapistListInfo.fromJson(Map<String, dynamic> json) {
    List<Specialization> specialization = [];

    json['main_focus'].forEach((spec) {
      specialization.add(Specialization.fromJson(spec));
    });

    return TherapistListInfo(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      jobId: json['job_id'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      mainFocus: specialization,
    );
  }
}
