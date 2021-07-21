import 'package:chips_choice/chips_choice.dart';
import 'package:esma3ny/data/models/client_models/health_profile_helper.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
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
          'Health Profile',
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
                print(snapshot.data.education);
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
                            title: Text('For another one'),
                            onChanged: (val) => state.changeForME(),
                          ),
                          state.isMe ? additionalFields() : SizedBox(),
                          TextFieldForm(
                            hint: 'Who referred you',
                            validate: FormBuilderValidators.required(context),
                            prefixIcon: Icons.person_add,
                            controller: state.referController,
                          ),
                          countryList(),
                          dropDown(
                            'Marital Status',
                            snapshot.data.maritalStatus,
                            (val) {
                              state.maritalStatus = val;
                            },
                          ),
                          numberOfChildrenDropDown(),
                          dropDown(
                            'Education',
                            snapshot.data.education,
                            (val) {
                              state.education = val;
                            },
                          ),
                          dropDown(
                            'Degree',
                            snapshot.data.degree,
                            (val) {
                              state.degree = val;
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Which services are you looking for?',
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
                          Text('What problem(s) are you seeking help for? *'),
                          problems(snapshot.data.problems),
                          Text('Problems Started Date *'),
                          datePicker(),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                                'Have any of your family members been diagnosed or treated for a psychiatric problem?'),
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
                                            ),
                                            onChanged: (value) {
                                              state.addSpecialization(i);
                                            },
                                          ),
                                        ),
                                      )
                                      .values
                                      .toList(),
                                )
                              : SizedBox(),
                          SizedBox(height: 20),
                          Text(
                              'Is there anything else you want your psychologist to know?'),
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
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text('submit')),
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
            labelText: 'Number of children',
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
              hint: 'Relation to client',
              validate: FormBuilderValidators.required(context),
              prefixIcon: Icons.person,
              controller: state.relation,
            ),
          ],
        ),
      );
}
