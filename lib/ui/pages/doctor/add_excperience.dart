import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/therapist/add_experience_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExperience extends StatefulWidget {
  @override
  _AddExperienceState createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  final key = GlobalKey<FormBuilderState>();
  TextEditingController _organizationEn = TextEditingController();
  TextEditingController _organizationAr = TextEditingController();
  TextEditingController _jobTitleEn = TextEditingController();
  TextEditingController _jobTitleAr = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  // ignore: unused_field
  int _selectedCountry;
  TextEditingController _city = TextEditingController();
  AddExperienceState _addExperienceState;
  TherapistProfileState _therapistProfileState;

  @override
  initState() {
    _addExperienceState =
        Provider.of<AddExperienceState>(context, listen: false);
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Experience',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<AddExperienceState>(
        builder: (context, state, child) => Padding(
          padding: EdgeInsets.all(8.0),
          child: FormBuilder(
            key: key,
            child: ListView(
              children: [
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Organization in English',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _organizationEn,
                  ),
                  error: state.errors['name_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Organization in Arabic',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _organizationAr,
                  ),
                  error: state.errors['name_ar'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Job Title in English',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _jobTitleEn,
                  ),
                  error: state.errors['title_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Job Title in Arabic',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _jobTitleAr,
                  ),
                  error: state.errors['title_ar'],
                ),
                datePickerFrom(),
                datePickerTo(),
                country(),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'City',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _city,
                  ),
                  error: state.errors['city'],
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState.validate()) {
                      await state.add(experience());
                      await _therapistProfileState.updateProfile();
                      if (state.isUpdated) Navigator.pop(context);
                    }
                  },
                  child: Text('Add Experience'),
                )
              ],
            ),
          ),
        ),
      );

  datePickerFrom() => ValidationError(
        textField: FormBuilderDateTimePicker(
          name: 'from',
          inputType: InputType.date,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_today,
              color: CustomColors.blue,
            ),
            labelText: 'From',
          ),
          format: DateFormat('yyyy-MM-dd'),
          controller: _from,
          validator: FormBuilderValidators.required(context),
          onChanged: (time) {},
        ),
        error: _addExperienceState.errors['from'],
      );

  datePickerTo() => ValidationError(
        textField: FormBuilderDateTimePicker(
          name: 'to',
          inputType: InputType.date,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_today,
              color: CustomColors.blue,
            ),
            labelText: 'To',
          ),
          format: DateFormat('yyyy-MM-dd'),
          controller: _to,
          onChanged: (time) {},
        ),
        error: _addExperienceState.errors['to'],
      );

  country() => FutureBuilder<List<Country>>(
        future: SharedPrefrencesHelper.getCountries,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? ValidationError(
                    textField: FormBuilderDropdown(
                      name: 'Country',
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.public,
                          color: CustomColors.blue,
                        ),
                        labelText: 'Country',
                      ),
                      validator: FormBuilderValidators.required(context),
                      items: snapshot.data
                          .map(
                            (Country country) => DropdownMenuItem(
                              child: Text(country.name),
                              value: country,
                              onTap: () {
                                _selectedCountry = country.id;
                              },
                            ),
                          )
                          .toList(),
                    ),
                    error: _addExperienceState.errors['country_id'],
                  )
                : SizedBox(),
      );

  Experience experience() {
    return Experience(
      name: LocaleString(
        stringEn: _organizationEn.text,
        stringAr: _organizationAr.text,
      ),
      title: LocaleString(
        stringEn: _jobTitleEn.text,
        stringAr: _jobTitleAr.text,
      ),
      from: _from.text,
      to: _to.text,
      city: _city.text,
      countryId: _selectedCountry,
    );
  }
}
