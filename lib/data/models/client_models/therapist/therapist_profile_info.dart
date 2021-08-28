import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:flutter/foundation.dart';

class Therapist {
  final id;
  final LocaleString name;
  final email;
  final phone;
  final gender;
  final dateOfBirth;
  final countryId;
  final prefix;
  final LocaleString biography;
  final joiningDate;
  final Fees fees;
  final Job job;
  final ProfileImage profileImage;
  final List<Specialization> specializations;
  final List<Specialization> mainFocus;
  final List<Certificate> certificates;
  final List<Education> educations;
  final List<Experience> experience;

  Therapist({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.biography,
    @required this.countryId,
    @required this.dateOfBirth,
    @required this.fees,
    @required this.gender,
    @required this.job,
    @required this.phone,
    @required this.prefix,
    @required this.profileImage,
    @required this.joiningDate,
    @required this.specializations,
    @required this.mainFocus,
    @required this.certificates,
    @required this.educations,
    @required this.experience,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    List<Specialization> specializationList = [];
    List<Specialization> mainFocusList = [];
    List<Certificate> certificateList = [];
    List<Education> educationList = [];
    List<Experience> experienceList = [];

    if (json['specializations'].isNotEmpty)
      json['specializations'].forEach((specialization) =>
          specializationList.add(Specialization.fromJson(specialization)));

    if (json['main_focus'].isNotEmpty)
      json['main_focus'].forEach(
          (mainFocus) => mainFocusList.add(Specialization.fromJson(mainFocus)));

    if (json['certificates'].isNotEmpty)
      json['certificates'].forEach((certificate) =>
          certificateList.add(Certificate.fromJson(certificate)));

    if (json['educations'].isNotEmpty)
      json['educations'].forEach(
          (education) => educationList.add(Education.formJson(education)));

    if (json['experiences'].isNotEmpty)
      json['experiences'].forEach(
          (experience) => experienceList.add(Experience.fromJson(experience)));

    return Therapist(
      id: json['id'],
      email: json['email'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
      biography: LocaleString(
        stringEn: json['biography_en'],
        stringAr: json['biography_ar'],
      ),
      countryId: json['country_id'],
      dateOfBirth: json['date_of_birth'],
      fees: json['fees'] == null ? null : Fees.fromJson(json['fees']),
      gender: json['gender'],
      joiningDate: json['created_at'],
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      phone: json['phone'],
      prefix: json['prefix'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      specializations: specializationList,
      mainFocus: mainFocusList,
      certificates: certificateList,
      educations: educationList,
      experience: experienceList,
    );
  }
}
