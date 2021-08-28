import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../theme/colors.dart';

class TextFieldForm extends StatelessWidget {
  final String hint;
  final dynamic validate;
  final IconData prefixIcon;
  final TextEditingController controller;
  final int maxLines;
  final AutovalidateMode autoValidateMode;
  TextFieldForm({
    @required this.hint,
    @required this.validate,
    @required this.prefixIcon,
    @required this.controller,
    this.maxLines = 1,
    this.autoValidateMode = AutovalidateMode.disabled,
  });
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: controller,
      name: hint,
      validator: validate,
      maxLines: maxLines,
      focusNode: focus,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(
          prefixIcon,
          color: CustomColors.blue,
        ),
      ),
      onSubmitted: (val) {
        FocusScope.of(context).requestFocus(focus);
      },
      autovalidateMode: autoValidateMode,
    );
  }
}
