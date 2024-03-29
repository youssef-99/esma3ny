import 'dart:io';

import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/ui/provider/therapist/basic_info_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:esma3ny/ui/widgets/textFields/passwordField.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditBasicInfoPage extends StatefulWidget {
  @override
  _EditBasicInfoPageState createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  final _key = GlobalKey<FormBuilderState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController nameAr = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  String selectedGender;
  int selectedCountry;
  String profileImage;

  List<String> genderOptions = ['male', 'female', 'other'];
  TherapistProfileState _therapistProfileState;
  EditBasicInfoState _editBasicInfoState;

  Future<void> initalValues() async {
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    TherapistProfileResponse _therapist =
        _therapistProfileState.therapistProfileResponse;

    name.text = _therapist.nameEn;
    nameAr.text = _therapist.nameAr;
    email.text = _therapist.email;
    phone.text = _therapist.phone;
    dateOfBirth.text = _therapist.dateOfBirth;
    print(_therapist.dateOfBirth);
    selectedGender = _therapist.gender;
    selectedCountry = int.parse(_therapist.countryId);
    profileImage = _therapist.profileImage.small;
    _editBasicInfoState =
        Provider.of<EditBasicInfoState>(context, listen: false);
  }

  @override
  void initState() {
    initalValues();
    super.initState();
  }

  File _image;
  final picker = ImagePicker();

  pickImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    _image = File(pickedImage.path);
    _editBasicInfoState.updateProfileImage(_image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Basic Info',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: FormBuilder(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Consumer<EditBasicInfoState>(
            builder: (context, state, widget) => ListView(
              children: [
                profileImageWidget(),
                changeImage(),
                nameFieldEn(),
                nameFieldAr(),
                emailField(),
                passwordField(),
                confirmPasswordField(),
                genderPicker(),
                datePicker(),
                countryPicker(),
                phoneField(),
                SizedBox(height: 10),
                state.loading
                    ? Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState.saveAndValidate()) {
                            await state.edit(therapist());
                            if (state.isupdated) {
                              await Provider.of<TherapistProfileState>(context,
                                      listen: false)
                                  .updateProfile();
                              Fluttertoast.showToast(
                                msg: 'Profile Updated Successfully',
                                backgroundColor: Colors.green,
                              );

                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.blue,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Edit',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileImageWidget() => Consumer<TherapistProfileState>(
        builder: (context, state, child) => CircleAvatar(
          radius: 100,
          child: CachedImage(
            url: state.therapistProfileResponse.profileImage.small,
            raduis: 100,
          ),
        ),
      );

  changeImage() => TextButton(
      onPressed: () =>
          showDialog(context: context, builder: (context) => choosePick()),
      child: Text('Change Your Profile Picture'));

  choosePick() => AlertDialog(
        title: Text('Choose Way'),
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        content: SizedBox(
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Gallery'),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      );

  nameFieldEn() => ValidationError(
        textField: TextFieldForm(
          hint: 'Name',
          validate: FormBuilderValidators.required(context),
          prefixIcon: Icons.person,
          controller: name,
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['name_en'],
      );

  nameFieldAr() => ValidationError(
        textField: TextFieldForm(
          hint: 'Name in arabic',
          validate: FormBuilderValidators.required(context),
          prefixIcon: Icons.person,
          controller: nameAr,
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['name_ar'],
      );

  emailField() => ValidationError(
        textField: TextFieldForm(
          prefixIcon: Icons.email,
          hint: 'Email',
          validate: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.email(context)
          ]),
          controller: email,
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['email'],
      );

  passwordField() => ValidationError(
        textField: PasswordFormField(
            controller: password, label: 'Password', require: false),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['password'],
      );

  confirmPasswordField() => ValidationError(
        textField: PasswordFormField(
          controller: confirmPassword,
          label: 'Confirm Password',
          require: false,
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['password_confirmation'],
      );

  genderPicker() => ValidationError(
        textField: FormBuilderDropdown(
          name: 'gender',
          decoration: InputDecoration(
              prefixIcon: prefixIcon(Icons.person), labelText: 'Gender'),
          allowClear: true,
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)]),
          initialValue: selectedGender,
          items: genderOptions
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text('$gender'),
                  ))
              .toList(),
          onSaved: (String value) {
            if (value != null) selectedGender = value.toLowerCase();
          },
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['gender'],
      );

  datePicker() => ValidationError(
        textField: FormBuilderDateTimePicker(
          name: 'Date Of Birth',
          inputType: InputType.date,
          format: DateFormat('yyyy-MM-dd'),
          controller: dateOfBirth,
          initialValue: DateTime.parse(dateOfBirth.text),
          initialDatePickerMode: DatePickerMode.year,
          decoration: InputDecoration(
            prefixIcon: prefixIcon(Icons.date_range),
            labelText: 'Date Of Birth',
          ),
          enabled: true,
          validator: FormBuilderValidators.required(context),
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['date_of_birth'],
      );

  countryPicker() => FutureBuilder<List<Country>>(
        future: _editBasicInfoState.countries,
        builder: (context, snapshot) => snapshot.hasData
            ? ValidationError(
                textField: FormBuilderDropdown(
                  name: 'country',
                  initialValue: snapshot.data[selectedCountry - 1].id,
                  decoration: InputDecoration(
                      prefixIcon: prefixIcon(Icons.person),
                      labelText: 'Country'),
                  allowClear: true,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  items: snapshot.data
                      .map((country) => DropdownMenuItem(
                            value: country.id,
                            child:
                                Text('+${country.code}      ${country.name}'),
                          ))
                      .toList(),
                  onSaved: (value) {
                    selectedCountry = value;
                  },
                ),
                error: Provider.of<EditBasicInfoState>(context, listen: false)
                    .errors['country_id'],
              )
            : SizedBox(),
      );

  phoneField() => ValidationError(
        textField: TextFieldForm(
          hint: 'Phone Number',
          validate: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.numeric(context),
          ]),
          prefixIcon: Icons.person,
          controller: phone,
        ),
        error: Provider.of<EditBasicInfoState>(context, listen: false)
            .errors['phone'],
      );

  therapist() {
    Therapist therapist = Therapist(
      name: name.text,
      nameAr: nameAr.text,
      email: email.text,
      phone: phone.text,
      gender: selectedGender,
      dateOfBirth: dateOfBirth.text,
      countryId: selectedCountry.toString(),
      password: password.text,
      confirmPassword: confirmPassword.text,
    );
    return therapist;
  }

  prefixIcon(IconData icon) => Icon(icon, color: CustomColors.blue);
}
