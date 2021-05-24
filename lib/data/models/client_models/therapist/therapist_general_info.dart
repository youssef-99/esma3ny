import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';

class TherapistListInfo {
  final id;
  final nameEn;
  final nameAr;
  final jobId;
  final titleEn;
  final titleAr;
  final ProfileImage profileImage;
  final Job job;

  TherapistListInfo({
    this.id,
    this.nameEn,
    this.nameAr,
    this.job,
    this.jobId,
    this.profileImage,
    this.titleAr,
    this.titleEn,
  });

  factory TherapistListInfo.fromJson(Map<String, dynamic> json) {
    return TherapistListInfo(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      jobId: json['job_id'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
    );
  }
}
