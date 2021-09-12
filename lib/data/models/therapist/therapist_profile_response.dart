import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:flutter/foundation.dart';

class TherapistProfileResponse {
  final id;
  final LocaleString name;
  final email;
  final phone;
  final gender;
  final dateOfBirth;
  final int countryId;
  final prefix;
  final LocaleString biography;
  final joiningDate;
  final jobId;
  final bool isStripeActivated;
  final bool hasForeignAccount;
  final Fees fees;
  final Job job;
  final ProfileImage profileImage;
  final List<Language> languages;
  final List<Specialization> specializations;
  final List<Specialization> mainFocus;
  final List<Certificate> certificates;
  final List<Education> educations;
  final List<Experience> experience;

  TherapistProfileResponse({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.biography,
    @required this.countryId,
    @required this.dateOfBirth,
    @required this.fees,
    @required this.jobId,
    @required this.gender,
    @required this.job,
    @required this.phone,
    @required this.prefix,
    @required this.languages,
    @required this.profileImage,
    @required this.joiningDate,
    @required this.specializations,
    @required this.mainFocus,
    @required this.certificates,
    @required this.educations,
    @required this.experience,
    @required this.isStripeActivated,
    @required this.hasForeignAccount,
  });

  factory TherapistProfileResponse.fromJson(Map<String, dynamic> json) {
    List<Specialization> specializationList = [];
    List<Specialization> mainFocusList = [];
    List<Certificate> certificateList = [];
    List<Education> educationList = [];
    List<Experience> experienceList = [];
    List<Language> languageList = [];

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

    if (json['languages'].isNotEmpty)
      json['languages']
          .forEach((language) => languageList.add(Language.fromJson(language)));

    return TherapistProfileResponse(
      id: json['id'],
      email: json['email'],
      name: LocaleString(
        stringEn: json['name_en'],
        stringAr: json['name_ar'],
      ),
      biography: LocaleString(
        stringEn: json['biography_en'] == '' ? 'Empty' : json['biography_en'],
        stringAr: json['biography_ar'] == '' ? 'Empty' : json['biography_ar'],
      ),
      countryId: json['country_id'],
      dateOfBirth: json['date_of_birth'],
      fees: json['fees'] == null ? null : Fees.fromJson(json['fees']),
      gender: json['gender'],
      joiningDate: json['created_at'],
      jobId: json['job_id'],
      job: json['job'] == null ? null : Job.fromJson(json['job']),
      phone: json['phone'],
      prefix: json['prefix'],
      profileImage: ProfileImage.fromjson(json['profile_image']),
      languages: languageList,
      specializations: specializationList,
      mainFocus: mainFocusList,
      certificates: certificateList,
      educations: educationList,
      experience: experienceList,
      hasForeignAccount: json['has_foreign_account'],
      isStripeActivated: json['stripe_connect_activated'],
    );
  }
}
