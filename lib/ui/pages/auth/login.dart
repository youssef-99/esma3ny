import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/ui/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormBuilderState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isClientPressed = true;
  bool _isTherapistPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: body(),
    );
  }

  body() => Center(
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
          ),
          child: SingleChildScrollView(
            child: column(),
          ),
        ),
      );

  column() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          logo(),
          roleButtons(),
          form(),
          forgotPassword(),
          confirmButton(),
          createOneText(),
        ],
      );

  logo() => Container(
        child: Hero(
          tag: 'logo',
          child: SvgPicture.asset('assets/images/logo.svg'),
        ),
      );

  roleButtons() => Container(
        margin: EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: CustomColors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            roleButton('Client', CustomColors.orange),
            roleButton('Therapist', CustomColors.blue),
          ],
        ),
      );

  roleButton(String role, Color color) => Expanded(
        child: InkWell(
          onTap: () {
            if (role == 'Client') {
              setState(() {
                _isClientPressed = true;
                _isTherapistPressed = false;
              });
            } else {
              setState(() {
                _isClientPressed = false;
                _isTherapistPressed = true;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: role == 'Client'
                  ? (_isClientPressed ? grediant(color) : null)
                  : (_isTherapistPressed ? grediant(color) : null),
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            child: Center(
              child: Text(
                role,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      );

  grediant(Color color) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black87,
          color,
        ],
      );

  form() => Consumer<LoginState>(
        builder: (context, state, widget) => FormBuilder(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.email(context)
                ]),
                controller: _email,
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'password',
                obscureText: state.showPassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () => state.changePsswordVisibilty(),
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ),
                validator: FormBuilderValidators.required(context),
                controller: _password,
              ),
              state.errors.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Invalid Credintails',
                        style: TextStyle(color: Colors.red, height: 2.5),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );

  forgotPassword() => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Forget Password',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      );

  confirmButton() => Consumer<LoginState>(
        builder: (context, state, widget) => state.loading
            ? Column(
                children: [
                  CircularProgressIndicator(),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors.blue,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () async {
                    _key.currentState.save();

                    if (_key.currentState.validate()) {
                      await state.login(
                          _email.text, _password.text, _isClientPressed);

                      if (state.exception == null) {
                        if (_isClientPressed)
                          Navigator.pushReplacementNamed(
                              context, 'Bottom_Nav_Bar');
                        else
                          Navigator.pushNamed(context, 'comming_soon');
                      }
                      handleException(state.exception);
                    }
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
      );

  createOneText() => TextButton(
        child: Text(
          'Create Account',
          style: TextStyle(
            color: CustomColors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, 'signup'),
      );

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
