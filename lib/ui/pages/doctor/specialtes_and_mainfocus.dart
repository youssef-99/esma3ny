import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/provider/therapist/specialities_state.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpecialitiesAndMainFocus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).specialization,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer2<TherapistProfileState, SpecialitiesState>(
          builder: (context, therapistState, specialitiesState, child) {
        specialitiesState.initValues(
          therapistState.specializations,
          therapistState.therapistProfileResponse.specializations,
          therapistState.therapistProfileResponse.mainFocus,
        );
        return Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: Main,
            children: [
              Text(
                AppLocalizations.of(context).specialization,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ValidationError(
                textField: Column(
                  children: therapistState.specializations
                      .map(
                        (Specialization specialization) => CheckboxListTile(
                          value: specialitiesState
                              .checkedSpecialization[specialization.id - 1],
                          title: Text(specialization.name.getLocalizedString()),
                          onChanged: (val) {
                            specialitiesState.setSpecialization(
                              specialization,
                              val,
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
                error: specialitiesState.errors['specializations'],
              ),
              Text(
                AppLocalizations.of(context).main_focus,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ValidationError(
                textField: Column(
                  children: therapistState.specializations
                      .map(
                        (Specialization mainFocus) => CheckboxListTile(
                          value: specialitiesState
                              .checkedMainFocus[mainFocus.id - 1],
                          title: Text(mainFocus.name.getLocalizedString()),
                          onChanged: (val) {
                            specialitiesState.setMainFocus(mainFocus, val);
                          },
                        ),
                      )
                      .toList(),
                ),
                error: specialitiesState.errors['main_focus'],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await specialitiesState.edit();
                  if (specialitiesState.isUpdated) Navigator.pop(context);
                },
                child: specialitiesState.loading
                    ? CustomProgressIndicator()
                    : Text(AppLocalizations.of(context).edit),
              )
            ],
          ),
        );
      });
}
