import 'dart:io';

import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/core/device_info/device_info.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/ui/provider/edit_profile_state.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/models/client_models/Client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';
import 'textFields/TextField.dart';
import 'textFields/passwordField.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _key = GlobalKey<FormBuilderState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  String selectedGender;
  int selectedCountry;
  String profileImage;

  List<String> genderOptions = ['male', 'female', 'other'];
  List<Country> countries = [];
  EditProfileState _editProfileState;

  initalValues() async {
    _editProfileState = Provider.of<EditProfileState>(context, listen: false);
    ClientModel client = _editProfileState.client;
    countries = await _editProfileState.countries;

    name.text = client.name;
    email.text = client.email;
    phone.text = client.phone;
    dateOfBirth.text = client.dateOfBirth;
    selectedGender = client.gender;
    selectedCountry = int.parse(client.countryId);
    profileImage = client.profilImage.small;
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
    _editProfileState.updateProfileImage(_image.path);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Consumer<EditProfileState>(
            builder: (context, state, widget) => ListView(
              children: [
                profileImageWidget(),
                changeImage(),
                nameField(),
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
                            await state.edit(await toClient(), true);
                            if (state.exception == null) {
                              Fluttertoast.showToast(
                                  msg: 'Profile Updated Successfully',
                                  backgroundColor: Colors.green);

                              Navigator.pop(context);
                            }
                            handleException(state.exception);
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

  profileImageWidget() => Consumer<EditProfileState>(
        builder: (context, state, child) => CircleAvatar(
          radius: 100,
          child: CachedImage(state.client.profilImage.small),
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

  nameField() => ValidationError(
        textField: TextFieldForm(
          hint: 'Name',
          validate: FormBuilderValidators.required(context),
          prefixIcon: Icons.person,
          controller: name,
        ),
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['name'],
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
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['email'],
      );

  passwordField() => ValidationError(
        textField: PasswordFormField(
            controller: password, label: 'Password', require: false),
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['password'],
      );

  confirmPasswordField() => ValidationError(
        textField: PasswordFormField(
          controller: confirmPassword,
          label: 'Confirm Password',
          require: false,
        ),
        error: Provider.of<EditProfileState>(context, listen: false)
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
        error: Provider.of<EditProfileState>(context, listen: false)
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
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['date_of_birth'],
      );

  countryPicker() => ValidationError(
        textField: FormBuilderDropdown(
          name: 'country',
          initialValue: countries[selectedCountry - 1].id,
          decoration: InputDecoration(
              prefixIcon: prefixIcon(Icons.person), labelText: 'Country'),
          allowClear: true,
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)]),
          items: countries
              .map((country) => DropdownMenuItem(
                    value: country.id,
                    child: Text('+${country.code}      ${country.name}'),
                  ))
              .toList(),
          onSaved: (value) {
            selectedCountry = value;
          },
        ),
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['country_id'],
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
        error: Provider.of<EditProfileState>(context, listen: false)
            .errors['phone'],
      );

  Future<ClientModel> toClient() async {
    ClientModel client = ClientModel(
      name: name.text,
      email: email.text,
      phone: phone.text,
      gender: selectedGender,
      dateOfBirth: dateOfBirth.text,
      countryId: selectedCountry.toString(),
      password: password.text,
      confirmPassword: confirmPassword.text,
    );
    return client;
  }

  therapist() async {
    Therapist therapist = Therapist(
      name: name.text,
      email: email.text,
      phone: phone.text,
      gender: selectedGender,
      dateOfBirth: dateOfBirth.text,
      countryId: selectedCountry.toString(),
      password: password.text,
      confirmPassword: confirmPassword.text,
      deviceName: await getDeviceName(),
    );
    return therapist;
  }

  prefixIcon(IconData icon) => Icon(icon, color: CustomColors.blue);
  handleException(Exceptions exceptions) {
    if (exceptions == null) return;
    if (exceptions == Exceptions.NetworkError) {
      print(exceptions);
      Fluttertoast.showToast(
          msg: 'Network error check your internet connection');
    } else if (exceptions == Exceptions.ServerError) {
      Fluttertoast.showToast(msg: 'Server error try again later');
    } else if (exceptions == Exceptions.Timeout) {
      Fluttertoast.showToast(msg: 'time out try again');
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
}
