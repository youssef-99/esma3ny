import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class ExperiencePage extends StatelessWidget {
  final TherapistProfileResponse therapistProfileResponse;

  const ExperiencePage({Key key, @required this.therapistProfileResponse})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Experience',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => ListView(
        children: [
          Column(
            children: [
              S2ChipsTile(
                values: therapistProfileResponse.specializations
                    .map((Specialization specialization) => S2Choice(
                          value: specialization.id,
                          title: specialization.nameEn,
                        ))
                    .toList(),
                onTap: null,
                title: Text('Specialties'),
              ),
              S2ChipsTile(
                values: therapistProfileResponse.mainFocus
                    .map((Specialization specialization) => S2Choice(
                          value: specialization.id,
                          title: specialization.nameEn,
                        ))
                    .toList(),
                onTap: null,
                title: Text('Main Focus '),
              ),
              titleTile('Experience'),
              experienceTileList(therapistProfileResponse.experience),
              titleTile('Education'),
              educationTileList(therapistProfileResponse.educations),
              titleTile('Certificate'),
              certificateTileList(therapistProfileResponse.certificates),
            ],
          ),
        ],
      );

  experienceTileList(List<Experience> experience) => Column(
        children: experience
            .map((Experience experience) => experienceTile(
                  experience.titleEn,
                  '${experience.nameEn} (${experience.from} - ${experience.to})',
                ))
            .toList(),
      );
  educationTileList(List<Education> education) => Column(
        children: education
            .map((Education education) => experienceTile(
                  education.degreeEn,
                  '${education.degreeEn} (${education.from} - ${education.to})',
                ))
            .toList(),
      );
  certificateTileList(List<Certificate> certificate) => Column(
        children: certificate
            .map((Certificate certificate) => experienceTile(
                  certificate.nameEn,
                  '${certificate.organizationEn} (${certificate.from - certificate.to})',
                ))
            .toList(),
      );

  Widget titleTile(String title) => ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Add More +'),
        ),
      );

  Widget experienceTile(String title, String data) => ListTile(
        leading: Icon(Icons.panorama_fish_eye_outlined),
        title: Text(title),
        subtitle: Text(data),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {},
        ),
      );
}
