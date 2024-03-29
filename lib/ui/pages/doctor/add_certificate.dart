import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/ui/provider/therapist/add_ceritficate_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCertificate extends StatefulWidget {
  @override
  _AddCertificateState createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  final key = GlobalKey<FormBuilderState>();
  TextEditingController _orgEn = TextEditingController();
  TextEditingController _orgAr = TextEditingController();
  TextEditingController _nameEn = TextEditingController();
  TextEditingController _nameAr = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  TextEditingController _licensingOrg = TextEditingController();
  TextEditingController _licensingNum = TextEditingController();

  TherapistProfileState _therapistProfileState;
  AddCertificateState _addCertificate;

  @override
  initState() {
    _addCertificate = Provider.of<AddCertificateState>(context, listen: false);
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

  body() => Consumer<AddCertificateState>(
        builder: (context, state, child) => Padding(
          padding: EdgeInsets.all(8.0),
          child: FormBuilder(
            key: key,
            child: ListView(
              children: [
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Issuing Organization In English ',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _orgEn,
                  ),
                  error: state.errors['organization_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Issuing Organization In Arabic',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _orgAr,
                  ),
                  error: state.errors['organization_ar'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Name in English',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _nameEn,
                  ),
                  error: state.errors['name_en'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Name in Arabic',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.home,
                    controller: _nameAr,
                  ),
                  error: state.errors['name_ar'],
                ),
                datePickerFrom(),
                datePickerTo(),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Licensing Organization',
                    validate: null,
                    prefixIcon: Icons.home,
                    controller: _licensingOrg,
                  ),
                  error: state.errors['licensing_organization'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'License Number',
                    validate: null,
                    prefixIcon: Icons.home,
                    controller: _licensingNum,
                  ),
                  error: state.errors['license_number'],
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState.validate()) {
                      await state.add(certificate());
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
        error: _addCertificate.errors['from'],
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
        error: _addCertificate.errors['to'],
      );

  Certificate certificate() => Certificate(
        organizationEn: _orgEn.text,
        organizationAr: _orgAr.text,
        from: _from.text,
        to: _to.text,
        licenseNumber: _licensingNum.text,
        licensingOrganization: _licensingOrg.text,
        nameAr: _nameEn.text,
        nameEn: _nameAr.text,
      );
}
