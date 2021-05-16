import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';

class EducationAndCertificate extends StatelessWidget {
  final Therapist therapist;
  EducationAndCertificate(this.therapist);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: [
        Text(
          'Educations',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        therapist.educations.isEmpty
            ? Center(
                child: Text('No Education Found'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: therapist.educations
                    .map((e) =>
                        customListTile(e.degreeEn, e.from, e.to, e.schoolEn))
                    .toList(),
              ),
        SizedBox(height: 40),
        Text(
          'Certificates',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        therapist.certificates.isEmpty
            ? Center(
                child: Text('No Certificats Found'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: therapist.certificates
                    .map((e) => customListTile(
                        e.nameEn, e.from, e.to, e.organizationEn))
                    .toList(),
              )
      ]),
    );
  }

  Widget customListTile(
          String title, String from, String to, String subTitle) =>
      ListTile(
        leading: Icon(Icons.brightness_1_outlined),
        title: Text(title),
        trailing: Text(
          '$from - $to',
          style: TextStyle(color: CustomColors.blue),
        ),
        subtitle: Text(subTitle),
      );
}
