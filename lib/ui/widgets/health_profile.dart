import 'package:esma3ny/data/models/therapist/client_health_profile.dart';
import 'package:flutter/material.dart';

class HealthProfileWidget extends StatelessWidget {
  final ClientHealthProfile _clientHealthProfile;

  const HealthProfileWidget(this._clientHealthProfile);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          _clientHealthProfile.forMe
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Name:'),
                    text(_clientHealthProfile.name),
                    Divider(),
                    title('Date of Birth:'),
                    text(_clientHealthProfile.dateOfBirth),
                    Divider(),
                    title('Gender:'),
                    text(_clientHealthProfile.gender),
                    Divider(),
                    title('Relation to Client:'),
                    text(_clientHealthProfile.relation),
                    Divider(),
                  ],
                )
              : SizedBox(),
          title('Refered by:'),
          text(_clientHealthProfile.refer),
          Divider(),
          title('Nationality:'),
          text(_clientHealthProfile.nationality),
          Divider(),
          title('Marital Status:'),
          text(_clientHealthProfile.maritalStatus),
          Divider(),
          title('Children:'),
          text(_clientHealthProfile.children),
          Divider(),
          title('Education:'),
          text(_clientHealthProfile.education.type),
          Divider(),
          title('Degree:'),
          text(_clientHealthProfile.education.degree),
          Divider(),
          title('Services:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.services
                .map((e) => text(e.toString()))
                .toList(),
          ),
          Divider(),
          title('Problems:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.problems
                .map((e) => text(e.toString()))
                .toList(),
          ),
          Divider(),
          title('Family Problems:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.familyProblem
                .map<Widget>(
                  (entry) => text('${entry.key}: ${entry.value}'),
                )
                .toList(),
          ),
          Divider(),
          title('Extra Notes:'),
          text(_clientHealthProfile.note ?? 'No extra notes'),
        ],
      ),
    );
  }

  Widget text(String text) => Text(
        '   $text',
        style: TextStyle(fontSize: 16),
      );
  Widget title(String text) => Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
}
