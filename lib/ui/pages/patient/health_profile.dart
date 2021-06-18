import 'package:chips_choice/chips_choice.dart';
import 'package:esma3ny/data/models/client_models/health_profile.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/client/health_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/country_list.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
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
        title: Text('Health Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<HealthProfileHelper>(
            future: initialData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                print(snapshot.data.education);
                return FormBuilder(
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Who referred you'),
                      ),
                      CountryList(name: 'Nationality'),
                      dropDown('Marital Status', snapshot.data.maritalStatus),
                      numberOfChildrenDropDown(),
                      dropDown('Education', snapshot.data.education),
                      dropDown('Degree', snapshot.data.degree),
                      Text('Which services are you looking for?'),
                      Column(
                        children: snapshot.data.services
                            .map(
                              (e) => CheckboxListTile(
                                  value: check,
                                  title: Text(e.value),
                                  onChanged: (value) {
                                    check = value;
                                  }),
                            )
                            .toList(),
                      ),
                      Text('What problem(s) are you seeking help for? *'),
                      problems(snapshot.data.problems),
                      Text('Problems Started Date *'),
                      datePicker(),
                      CheckboxListTile(
                        title: Text(
                            'Have any of your family members been diagnosed or treated for a psychiatric problem?'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      Text(
                          'Is there anything else you want your psychologist to know?'),
                      TextFormField(
                        minLines: 1,
                        maxLines: 10,
                      ),
                      ElevatedButton(onPressed: () {}, child: Text('submit')),
                    ],
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

  dropDown(String name, List<MapEntry<String, String>> list) =>
      FormBuilderDropdown(
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
        onSaved: (value) {
          setState(() {});
        },
      );

  numberOfChildrenDropDown() => FormBuilderDropdown(
        name: 'Number of children',
        decoration: InputDecoration(
          prefixIcon: prefixIcon(Icons.person),
          labelText: 'Number of children',
        ),
        allowClear: true,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        items: List.generate(20, (index) => ++index)
            .map((element) => DropdownMenuItem<int>(
                  value: element,
                  child: Text(element.toString()),
                ))
            .toList(),
        onSaved: (value) {
          setState(() {});
        },
      );

  prefixIcon(IconData icon) => Icon(icon, color: CustomColors.blue);

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

  datePicker() => FormBuilderDateTimePicker(
        name: 'Date Of Birth',
        inputType: InputType.date,
        format: DateFormat('yyyy-MM-dd'),
        // controller: dateOfBirth,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime.now().subtract(Duration(days: 20000)),
        lastDate: DateTime.now().add(Duration(days: 20000)),
        enabled: true,
        validator: FormBuilderValidators.required(context),
      );
}
