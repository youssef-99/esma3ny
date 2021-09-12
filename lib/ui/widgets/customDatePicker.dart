import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  final _dateController;
  CustomDatePicker(this._dateController);
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  DateFormat _format = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._dateController,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).select_date,
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        widget._dateController.text = _format.format(picked).toString();
      });
  }
}
