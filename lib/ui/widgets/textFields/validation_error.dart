import 'package:flutter/material.dart';

class ValidationError extends StatefulWidget {
  final error;
  final Widget textField;
  ValidationError({
    @required this.error,
    @required this.textField,
  });
  @override
  _ValidationErrorState createState() => _ValidationErrorState();
}

class _ValidationErrorState extends State<ValidationError> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.textField,
        SizedBox(height: 5),
        widget.error != null
            ? Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  widget.error
                      .toString()
                      .substring(1, widget.error.toString().length - 2),
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
