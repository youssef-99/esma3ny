import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/colors.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final label;
  final require;
  PasswordFormField(
      {@required this.controller,
      @required this.label,
      @required this.require});
  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'Password',
      controller: widget.controller,
      validator: widget.controller.text.isEmpty && !widget.require
          ? (String val) => null
          : FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(context),
                FormBuilderValidators.minLength(context, 8,
                    errorText: AppLocalizations.of(context).password_8_char),
                (String val) {
                  if (!val.contains(RegExp(r'[A-Z]'))) {
                    return AppLocalizations.of(context).password_upper_char;
                  }
                  if (!val.contains(RegExp(r'[a-z]'))) {
                    return AppLocalizations.of(context).password_lower_char;
                  }
                  return null;
                }
              ],
            ),
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          icon: Icon(Icons.remove_red_eye),
          color: showPassword ? CustomColors.blue : CustomColors.black,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: CustomColors.blue,
        ),
      ),
    );
  }
}
