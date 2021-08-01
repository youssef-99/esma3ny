import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExperiencePage extends StatelessWidget {
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

  body() => Consumer<TherapistProfileState>(
        builder: (context, state, child) => ListView(
          children: [
            Column(
              children: [
                titleTile('Experience',
                    () => Navigator.pushNamed(context, 'add_experience')),
                experienceTileList(state.therapistProfileResponse.experience),
                titleTile('Education',
                    () => Navigator.pushNamed(context, 'add_education')),
                educationTileList(state.therapistProfileResponse.educations),
                titleTile('Certificate',
                    () => Navigator.pushNamed(context, 'add_certificate')),
                certificateTileList(
                    state.therapistProfileResponse.certificates),
              ],
            ),
          ],
        ),
      );

  experienceTileList(List<Experience> experience) =>
      Consumer<TherapistProfileState>(
        builder: (context, state, child) => Column(
          children: experience
              .map((Experience experience) => experienceTile(
                    experience.title.getLocalizedString(),
                    '${experience.name.getLocalizedString()} (${experience.from} - ${experience.to})',
                    () async {
                      await state.deleteExperience(experience.id);
                      await state.updateProfile();
                    },
                  ))
              .toList(),
        ),
      );
  educationTileList(List<Education> education) =>
      Consumer<TherapistProfileState>(
        builder: (context, state, child) => Column(
          children: education
              .map(
                (Education education) => experienceTile(
                  education.degree.getLocalizedString(),
                  '${education.degree.getLocalizedString()} (${education.from} - ${education.to})',
                  () async {
                    await state.deleteEducation(education.id);
                    await state.updateProfile();
                  },
                ),
              )
              .toList(),
        ),
      );
  certificateTileList(List<Certificate> certificate) =>
      Consumer<TherapistProfileState>(
        builder: (context, state, child) => Column(
          children: certificate
              .map((Certificate certificate) => experienceTile(
                    certificate.name.getLocalizedString(),
                    '${certificate.organization.getLocalizedString()} (${certificate.from} - ${certificate.to})',
                    () async {
                      await state.deleteCertificate(certificate.id);
                      await state.updateProfile();
                    },
                  ))
              .toList(),
        ),
      );

  Widget titleTile(String title, Function onTap) => ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: () => onTap(),
          child: Text('Add More +'),
        ),
      );

  Widget experienceTile(String title, String data, Function onDelete) =>
      ListTile(
        leading: Icon(Icons.panorama_fish_eye_outlined),
        title: Text(title),
        subtitle: Text(data),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => onDelete(),
        ),
      );
}
