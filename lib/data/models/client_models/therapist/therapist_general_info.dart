import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';

class TherapistListInfo {
  final id;
  final LocaleString name;
  final jobId;
  final LocaleString title;
  final ProfileImage profileImage;
  final Job job;

  TherapistListInfo({
    this.id,
    this.name,
    this.job,
    this.jobId,
    this.profileImage,
    this.title,
  });

  factory TherapistListInfo.fromJson(Map<String, dynamic> json) {
    return TherapistListInfo(
      id: json['id'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      jobId: json['job_id'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      title: LocaleString(
        stringAr: json['title_ar'],
        stringEn: json['title_en'],
      ),
    );
  }
}
