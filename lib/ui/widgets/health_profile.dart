import 'package:esma3ny/data/models/therapist/client_health_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    title('${AppLocalizations.of(context).name}:'),
                    text(_clientHealthProfile.name),
                    Divider(),
                    title('${AppLocalizations.of(context).date_of_birth}:'),
                    text(_clientHealthProfile.dateOfBirth),
                    Divider(),
                    title('${AppLocalizations.of(context).client}:'),
                    text(_clientHealthProfile.gender),
                    Divider(),
                    title(
                        '${AppLocalizations.of(context).relation_to_client}:'),
                    text(_clientHealthProfile.relation),
                    Divider(),
                  ],
                )
              : SizedBox(),
          title('${AppLocalizations.of(context).referred_by}:'),
          text(_clientHealthProfile.refer),
          Divider(),
          title('${AppLocalizations.of(context).nationality}:'),
          text(_clientHealthProfile.nationality),
          Divider(),
          title('${AppLocalizations.of(context).marital_status}:'),
          text(_clientHealthProfile.maritalStatus),
          Divider(),
          title('${AppLocalizations.of(context).number_of_children}:'),
          text(_clientHealthProfile.children),
          Divider(),
          title('${AppLocalizations.of(context).education}:'),
          text(_clientHealthProfile.education.type),
          Divider(),
          title('${AppLocalizations.of(context).degree}:'),
          text(_clientHealthProfile.education.degree),
          Divider(),
          title('${AppLocalizations.of(context).services}:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.services
                .map((e) => text(e.toString()))
                .toList(),
          ),
          Divider(),
          title('${AppLocalizations.of(context).problems}:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.problems
                .map((e) => text(e.toString()))
                .toList(),
          ),
          Divider(),
          title('${AppLocalizations.of(context).family_problems}:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clientHealthProfile.familyProblem
                .map<Widget>(
                  (entry) => text('${entry.key}: ${entry.value}'),
                )
                .toList(),
          ),
          Divider(),
          title('${AppLocalizations.of(context).extra_notes}:'),
          text(_clientHealthProfile.note ??
              '${AppLocalizations.of(context).no_extra_notes}'),
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
