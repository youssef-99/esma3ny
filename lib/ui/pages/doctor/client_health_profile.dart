import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientHealthProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Consumer<CallState>(
        builder: (context, state, child) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              state.clientHealthProfile.forMe == '0'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title('Name:'),
                        text(state.clientHealthProfile.name),
                        Divider(),
                        title('Date of Birth:'),
                        text(state.clientHealthProfile.dateOfBirth),
                        Divider(),
                        title('Gender:'),
                        text(state.clientHealthProfile.gender),
                        Divider(),
                        title('Relation to Client:'),
                        text(state.clientHealthProfile.relation),
                        Divider(),
                      ],
                    )
                  : SizedBox(),
              title('Refered by:'),
              text(state.clientHealthProfile.refer),
              Divider(),
              title('Nationality:'),
              text(state.clientHealthProfile.nationality),
              Divider(),
              title('Marital Status:'),
              text(state.clientHealthProfile.maritalStatus),
              Divider(),
              title('Children:'),
              text(state.clientHealthProfile.children),
              Divider(),
              title('Education:'),
              text(state.clientHealthProfile.education.type),
              Divider(),
              title('Degree:'),
              text(state.clientHealthProfile.education.degree),
              Divider(),
              title('Services:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.clientHealthProfile.services
                    .map((e) => text(e.toString()))
                    .toList(),
              ),
              Divider(),
              title('Problems:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.clientHealthProfile.problems
                    .map((e) => text(e.toString()))
                    .toList(),
              ),
              Divider(),
              title('Family Problems:'),
              text(state.clientHealthProfile.familyProblem.toString()),
              Divider(),
              title('Extra Notes:'),
              text(state.clientHealthProfile.note ?? 'No extra notes'),
            ],
          ),
        ),
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
