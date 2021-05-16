import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/data/models/public/job.dart';

class TherapistListInfo {
  final id;
  final nameEn;
  final nameAr;
  final jobId;
  final Fees fees;
  final titleEn;
  final titleAr;
  final profileImage;
  final Job job;

  TherapistListInfo({
    this.id,
    this.nameEn,
    this.nameAr,
    this.fees,
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
      fees: json['fees'].isEmpty ? null : Fees.fromJson(json['fees']),
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      jobId: json['job_id'],
      profileImage: json['profile_image']['high'],
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
    );
  }
}
