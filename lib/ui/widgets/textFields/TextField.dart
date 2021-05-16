import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../theme/colors.dart';

class TextFieldForm extends StatelessWidget {
  final String hint;
  final dynamic validate;
  final IconData prefixIcon;
  final TextEditingController controller;
  TextFieldForm({
    @required this.hint,
    @required this.validate,
    @required this.prefixIcon,
    @required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: controller,
      name: hint,
      validator: validate,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(
          prefixIcon,
          color: CustomColors.blue,
        ),
      ),
    );
  }
}
