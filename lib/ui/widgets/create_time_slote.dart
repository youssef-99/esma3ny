import 'package:esma3ny/ui/provider/therapist/calendar_state.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTimeSlot extends StatefulWidget {
  @override
  _CreateTimeSlotState createState() => _CreateTimeSlotState();
}

class _CreateTimeSlotState extends State<CreateTimeSlot> {
  final key = GlobalKey<FormBuilderState>();
  final TextEditingController _startDay = TextEditingController();
  final TextEditingController _startTime = TextEditingController();
  final TextEditingController _endDay = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarState>(
      builder: (context, state, child) => Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // date picker
                ValidationError(
                  textField: FormBuilderDateTimePicker(
                    name: 'start day',
                    controller: _startDay,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: AppLocalizations.of(context).start_day,
                    ),
                    validator: FormBuilderValidators.required(context),
                    format: DateFormat('yyyy-MM-dd'),
                    inputType: InputType.date,
                  ),
                  error: state.errors['start_day'],
                ),
                // time picker
                ValidationError(
                  textField: FormBuilderDateTimePicker(
                    name: 'start time',
                    controller: _startTime,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_clock),
                      hintText: AppLocalizations.of(context).strat_time,
                    ),
                    validator: FormBuilderValidators.required(context),
                    inputType: InputType.time,
                  ),
                  error: state.errors['start_time'],
                ),
                // drob down
                ValidationError(
                  textField: FormBuilderDropdown(
                    name: 'duration',
                    validator: FormBuilderValidators.required(context),
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).duration,
                        prefixIcon: Icon(Icons.timer)),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: '60',
                        child: Text('60 ${AppLocalizations.of(context).min}'),
                      ),
                      DropdownMenuItem(
                        value: '30',
                        child: Text('30 ${AppLocalizations.of(context).min}'),
                      ),
                    ],
                    onChanged: (String value) => state.setDuration(value),
                  ),
                  error: state.errors['duration'],
                ),
                // date picker
                state.isBulk
                    ? ValidationError(
                        textField: FormBuilderDateTimePicker(
                          name: 'end day',
                          controller: _endDay,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            hintText: AppLocalizations.of(context).end_day,
                          ),
                          format: DateFormat('yyyy-MM-dd'),
                          validator: FormBuilderValidators.required(context),
                          inputType: InputType.date,
                        ),
                        error: state.errors['end_day'],
                      )
                    : SizedBox(),
                // chek box
                FormBuilderCheckbox(
                  name: 'is bulk',
                  initialValue: state.isBulk,
                  title: Text(AppLocalizations.of(context).create_bulk),
                  onChanged: (value) {
                    state.setIsBulk(value);
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState.validate()) {
                      if (await state.createNewTimeSlot(
                        startDay: _startDay.text,
                        startTime: _startTime.text,
                        endDay: _endDay.text,
                      )) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: state.isCreating
                      ? CustomProgressIndicator()
                      : Text(AppLocalizations.of(context).submit),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
