import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/provider/public/roleState.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final key = GlobalKey<FormBuilderState>();
  final TextEditingController _email = TextEditingController();
  PublicRepository publicRepository = PublicRepository();
  bool isValidEmail = true;
  Map<String, dynamic> errors = {};
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              roleButtons(),
              ValidationError(
                error: errors == null ? null : errors['email'],
                textField: FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).email,
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context)
                  ]),
                  controller: _email,
                ),
              ),
              SizedBox(height: 30),
              confirmButton()
            ],
          ),
        ),
      ),
    );
  }

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
            roleButton(
                AppLocalizations.of(context).client, CustomColors.orange),
            roleButton(
                AppLocalizations.of(context).therapist, CustomColors.blue),
          ],
        ),
      );

  roleButton(String role, Color color) => Consumer<RoleState>(
        builder: (context, state, child) => Expanded(
          child: InkWell(
            onTap: () {
              if (role == AppLocalizations.of(context).client) {
                state.clientPressed();
              } else {
                state.therapistPressed();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: role == AppLocalizations.of(context).client
                    ? (state.client ? grediant(color) : null)
                    : (state.therapist ? grediant(color) : null),
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

  confirmButton() => Consumer<RoleState>(
        builder: (context, roleState, widget) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:
                  roleState.client ? CustomColors.orange : CustomColors.blue,
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () async {
              key.currentState.save();

              if (key.currentState.validate()) {
                loading = true;
                errors.clear();
                setState(() {});
                try {
                  await publicRepository.forgetPassword(
                      roleState.client, _email.text);
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context).reset_email_sent,
                      backgroundColor: Colors.green);
                } on InvalidData catch (e) {
                  print(e.errors);
                  setState(() {
                    errors = e.errors;
                  });
                }

                loading = false;
                setState(() {});
              }
            },
            child: loading
                ? CustomProgressIndicator()
                : Text(
                    AppLocalizations.of(context).send_reset_email,
                    style: Theme.of(context).textTheme.headline6,
                  ),
          ),
        ),
      );
}
