import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/core/device_info/device_info.dart';
import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/provider/public/roleState.dart';
import 'package:esma3ny/ui/provider/public/signup_form_state.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../theme/colors.dart';
import 'textFields/TextField.dart';
import 'textFields/passwordField.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _key = GlobalKey<FormBuilderState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  String selectedGender;
  int selectedCountry;

  List<String> genderOptions = ['Male', 'Female', 'Other'];
  List<Country> countries = [];
  PublicRepository _publicRepository = PublicRepository();

  _getCountries() async {
    try {
      await _publicRepository.getCountries();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occured check your internet connection',
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
      );
    }
  }

  fetchCountries() async {
    if (countries == null) {
      await _getCountries();
    }
    countries = await SharedPrefrencesHelper.getCountries;
    setState(() {});
  }

  @override
  void initState() {
    fetchCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SignupState, RoleState>(
      builder: (context, signupState, roleState, widget) => FormBuilder(
        key: _key,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: ListView(
              children: [
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Name',
                    validate: FormBuilderValidators.required(context),
                    prefixIcon: Icons.person,
                    controller: name,
                  ),
                  error: signupState.errors['name'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    prefixIcon: Icons.email,
                    hint: 'Email',
                    validate: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context)
                    ]),
                    controller: email,
                  ),
                  error: signupState.errors['email'],
                ),
                ValidationError(
                  textField: PasswordFormField(
                      controller: password, label: 'Password', require: true),
                  error: signupState.errors['password'],
                ),
                ValidationError(
                  textField: PasswordFormField(
                    controller: confirmPassword,
                    label: 'Confirm Password',
                    require: true,
                  ),
                  error: signupState.errors['password_confirmation'],
                ),
                ValidationError(
                  textField: FormBuilderDropdown(
                    name: 'gender',
                    decoration: InputDecoration(
                        prefixIcon: prefixIcon(Icons.person),
                        labelText: 'Gender'),
                    allowClear: true,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
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
                  error: signupState.errors['gender'],
                ),
                ValidationError(
                  textField: FormBuilderDateTimePicker(
                    name: 'Date Of Birth',
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
                    controller: dateOfBirth,
                    initialDatePickerMode: DatePickerMode.year,
                    decoration: InputDecoration(
                      prefixIcon: prefixIcon(Icons.date_range),
                      labelText: 'Date Of Birth',
                    ),
                    enabled: true,
                    validator: FormBuilderValidators.required(context),
                  ),
                  error: signupState.errors['date_of_birth'],
                ),
                ValidationError(
                  textField: FormBuilderDropdown(
                    name: 'country',
                    decoration: InputDecoration(
                        prefixIcon: prefixIcon(Icons.person),
                        labelText: 'Country'),
                    allowClear: true,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: countries
                        .map((country) => DropdownMenuItem(
                              value: country.id,
                              child:
                                  Text('+${country.code}      ${country.name}'),
                            ))
                        .toList(),
                    onSaved: (value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                  error: signupState.errors['country_id'],
                ),
                ValidationError(
                  textField: TextFieldForm(
                    hint: 'Phone Number',
                    validate: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                    ]),
                    prefixIcon: Icons.person,
                    controller: phone,
                  ),
                  error: signupState.errors['phone'],
                ),
                FormBuilderCheckbox(
                  name: 'agree',
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10)),
                  validator: FormBuilderValidators.equal(context, true,
                      errorText:
                          'You should accept the terms and condition to continue'),
                  title: Row(
                    children: [
                      Text(
                        'I accept the ',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        'terms and conditions',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: CustomColors.blue),
                      )
                    ],
                  ),
                  initialValue: false,
                  // tristate: true,
                ),
                signupState.loading
                    ? Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState.saveAndValidate()) {
                            if (roleState.client) {
                              await signupState.signup(
                                  await client(), roleState.client);
                            } else {
                              await signupState.signup(
                                  await therapist(), roleState.client);
                            }

                            if (signupState.exception == null) {
                              if (roleState.client)
                                Navigator.pushReplacementNamed(
                                    context, 'Bottom_Nav_Bar');
                              else
                                Navigator.pushNamed(context, 'comming_soon');
                            }

                            handleException(signupState.exception);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.blue,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Sign up',
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

  client() async {
    ClientModel client = ClientModel(
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
