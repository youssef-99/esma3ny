import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/ui/provider/therapist/add_education_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEducation extends StatefulWidget {
  @override
  _AddEducationState createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  final key = GlobalKey<FormBuilderState>();
  TextEditingController _schoolEn = TextEditingController();
  TextEditingController _schoolAr = TextEditingController();
  TextEditingController _degreeEn = TextEditingController();
  TextEditingController _degreeAr = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  AddEducationState _addExperienceState;
  TherapistProfileState _therapistProfileState;

  @override
  initState() {
    _addExperienceState =
        Provider.of<AddEducationState>(context, listen: false);
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).add_experience,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<AddEducationState>(
        builder: (context, state, child) => Padding(
          padding: EdgeInsets.all(8.0),
          child: FormBuilder(
            key: key,
            child: ListView(
              children: [
                ValidationError(
                  textField: TextFieldForm(
                    hint: AppLocalizations.of(context).school_in_english,
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _schoolEn,
                  ),
                  error: state.errors['school_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: AppLocalizations.of(context).school_in_arabic,
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _schoolAr,
                  ),
                  error: state.errors['school_ar'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: AppLocalizations.of(context).degree_in_arabic,
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _degreeEn,
                  ),
                  error: state.errors['degree_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: AppLocalizations.of(context).degree_in_arabic,
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _degreeAr,
                  ),
                  error: state.errors['degree_ar'],
                ),
                datePickerFrom(),
                datePickerTo(),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState.validate()) {
                      await state.add(education());
                      await _therapistProfileState.updateProfile();
                      if (state.isUpdated) Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context).add_experience),
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
            labelText: AppLocalizations.of(context).from,
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
            labelText: AppLocalizations.of(context).to,
          ),
          format: DateFormat('yyyy-MM-dd'),
          controller: _to,
          onChanged: (time) {},
        ),
        error: _addExperienceState.errors['to'],
      );

  Education education() {
    return Education(
      degree: LocaleString(
        stringAr: _degreeAr.text,
        stringEn: _degreeEn.text,
      ),
      from: _from.text,
      school: LocaleString(
        stringAr: _schoolAr.text,
        stringEn: _schoolEn.text,
      ),
      to: _to.text,
    );
  }
}
