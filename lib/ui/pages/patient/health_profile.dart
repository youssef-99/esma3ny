import 'package:chips_choice/chips_choice.dart';
import 'package:esma3ny/data/models/client_models/health_profile_helper.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/provider/client/health_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/country_list.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HealthProfile extends StatefulWidget {
  @override
  _HealthProfileState createState() => _HealthProfileState();
}

class _HealthProfileState extends State<HealthProfile> {
  List<Country> countries;
  bool check = false;
  final key = GlobalKey<FormBuilderState>();

  Future<HealthProfileHelper> initialData() async {
    countries = await SharedPrefrencesHelper.getCountries;
    HealthProfileHelper healthProfileHelper =
        await Provider.of<HealthProfileState>(context, listen: false)
            .getHealthProfileData();
    return healthProfileHelper;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).health_profile,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<HealthProfileHelper>(
            future: initialData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Consumer<HealthProfileState>(
                  builder: (context, state, child) => FormBuilder(
                    key: key,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: state.isMe,
                            title: Text(
                              AppLocalizations.of(context).for_another_one,
                            ),
                            onChanged: (val) => state.changeForME(),
                          ),
                          state.isMe ? additionalFields() : SizedBox(),
                          TextFieldForm(
                            hint: AppLocalizations.of(context).who_referred_you,
                            validate: FormBuilderValidators.required(context),
                            prefixIcon: Icons.person_add,
                            controller: state.referController,
                          ),
                          countryList(),
                          dropDown(
                            AppLocalizations.of(context).marital_status,
                            snapshot.data.maritalStatus,
                            (val) {
                              state.maritalStatus = val;
                            },
                          ),
                          numberOfChildrenDropDown(),
                          dropDown(
                            AppLocalizations.of(context).education,
                            snapshot.data.education,
                            (val) {
                              state.education = val;
                            },
                          ),
                          dropDown(
                            AppLocalizations.of(context).degree,
                            snapshot.data.degree,
                            (val) {
                              state.degree = val;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)
                                .which_services_are_you_looking_for,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: snapshot.data.services
                                .asMap()
                                .map(
                                  (i, e) => MapEntry(
                                    i,
                                    CheckboxListTile(
                                      value: state.services[i],
                                      title: Text(e.value),
                                      onChanged: (value) {
                                        state.addService(i);
                                      },
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                          Text(AppLocalizations.of(context)
                              .what_problems_are_you_seeking_help_for),
                          problems(snapshot.data.problems),
                          Text(AppLocalizations.of(context)
                              .problems_started_date),
                          datePicker(),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              AppLocalizations.of(context)
                                  .have_any_of_your_family_members_been_diagnosed_or_treated_for_a_psychiatric_problem,
                            ),
                            value: state.isFamilyProblem,
                            onChanged: (value) {
                              state.isFamilyProblemPressed();
                            },
                          ),
                          state.isFamilyProblem
                              ? Column(
                                  children: state.specializations
                                      .asMap()
                                      .map(
                                        (i, e) => MapEntry(
                                          i,
                                          CheckboxListTile(
                                            value: state
                                                .specializationSelections[i],
                                            title: Text(
                                                e.name.getLocalizedString()),
                                            subtitle: TextField(
                                                controller:
                                                    state.familyProblemNotes[i],
                                                decoration: InputDecoration(
                                                  errorText: state
                                                          .validateFamily[i]
                                                      ? AppLocalizations.of(
                                                              context)
                                                          .field_cant_be_empty
                                                      : null,
                                                )),
                                            onChanged: (value) {
                                              state.addSpecialization(i, value);
                                            },
                                          ),
                                        ),
                                      )
                                      .values
                                      .toList(),
                                )
                              : SizedBox(),
                          SizedBox(height: 20),
                          Text(AppLocalizations.of(context)
                              .is_there_anything_else_you_want_your_psychologist_to_know),
                          TextFormField(
                            minLines: 1,
                            maxLines: 10,
                            controller: state.notes,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                if (key.currentState.validate()) {
                                  await state.submitHealthProfile();
                                  if (state.isDone) {
                                    Provider.of<BookSessionState>(context,
                                            listen: false)
                                        .setProfileCompelete(true);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: state.loading
                                  ? CustomProgressIndicator()
                                  : Text(AppLocalizations.of(context).submit)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return ErrorIndicator(error: snapshot.error);
              }

              return CustomProgressIndicator();
            }),
      ),
    );
  }

  dropDown(String name, List<MapEntry<String, String>> list,
          Function onChanged) =>
      Consumer<HealthProfileState>(
        builder: (context, state, child) => FormBuilderDropdown(
          name: name,
          decoration: InputDecoration(
            prefixIcon: prefixIcon(Icons.person),
            labelText: name,
          ),
          allowClear: true,
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)]),
          items: list
              .map((element) => DropdownMenuItem<String>(
                    value: element.key,
                    child: Text(element.value),
                  ))
              .toList(),
          onChanged: (val) => onChanged(val),
        ),
      );

  numberOfChildrenDropDown() => Consumer<HealthProfileState>(
        builder: (context, state, child) => FormBuilderDropdown(
          name: 'Number of children',
          decoration: InputDecoration(
            prefixIcon: prefixIcon(Icons.person),
            labelText: AppLocalizations.of(context).number_of_children,
          ),
          allowClear: true,
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)]),
          items: List.generate(21, (index) => index++)
              .map((element) => DropdownMenuItem<int>(
                    value: element,
                    child: Text(element.toString()),
                  ))
              .toList(),
          onChanged: (int value) {
            state.numberOfChildren = value;
          },
        ),
      );

  prefixIcon(IconData icon) => Icon(icon, color: CustomColors.blue);

  countryList() => Consumer<HealthProfileState>(
        builder: (context, state, child) => CountryList(
          name: 'Nationality',
          countries: countries,
          onChange: (int val) {
            state.countryId = val;
          },
        ),
      );

  problems(List<MapEntry<String, String>> problems) =>
      Consumer<HealthProfileState>(
        builder: (context, state, child) => ChipsChoice<int>.multiple(
          value: state.problems,
          onChanged: (val) => state.setProblems(val),
          choiceItems: C2Choice.listFrom<int, MapEntry<String, String>>(
              source: problems,
              value: (i, v) => i,
              label: (i, v) => v.value,
              tooltip: (i, v) => v.key,
              style: (i, v) {
                return C2ChoiceStyle(labelStyle: TextStyle(fontSize: 18));
              }),
          choiceActiveStyle: C2ChoiceStyle(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: CustomColors.orange,
          ),
          wrapped: true,
        ),
      );

  datePicker() => Consumer<HealthProfileState>(
        builder: (context, state, child) => FormBuilderDateTimePicker(
          name: 'Date Of Birth for another one',
          inputType: InputType.date,
          format: DateFormat('yyyy-MM'),
          controller: state.problemStartedAt,
          initialDatePickerMode: DatePickerMode.year,
          firstDate: DateTime.now().subtract(Duration(days: 20000)),
          lastDate: DateTime.now().add(Duration(days: 20000)),
          enabled: true,
          validator: FormBuilderValidators.required(context),
        ),
      );

  additionalFields() => Consumer<HealthProfileState>(
        builder: (context, state, child) => Column(
          children: [
            TextFieldForm(
              hint: 'Name',
              validate: FormBuilderValidators.required(context),
              prefixIcon: Icons.person,
              controller: state.name,
            ),
            FormBuilderDropdown(
              name: 'gender',
              decoration: InputDecoration(
                  prefixIcon: prefixIcon(Icons.person), labelText: 'Gender'),
              allowClear: true,
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required(context)]),
              items: state.genderOptions
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text('$gender'),
                      ))
                  .toList(),
              onSaved: (String value) {
                if (value != null) state.selectedGender = value.toLowerCase();
              },
            ),
            FormBuilderDateTimePicker(
              name: 'Date Of Birth',
              inputType: InputType.date,
              format: DateFormat('yyyy-MM-dd'),
              controller: state.dateOfBirth,
              initialDatePickerMode: DatePickerMode.year,
              decoration: InputDecoration(
                prefixIcon: prefixIcon(Icons.date_range),
                labelText: 'Date Of Birth',
              ),
              enabled: true,
              validator: FormBuilderValidators.required(context),
            ),
            TextFieldForm(
              hint: AppLocalizations.of(context).relation_to_client,
              validate: FormBuilderValidators.required(context),
              prefixIcon: Icons.person,
              controller: state.relation,
            ),
          ],
        ),
      );
}
