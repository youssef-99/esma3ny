import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HealthProfile extends StatefulWidget {
  @override
  _HealthProfileState createState() => _HealthProfileState();
}

class _HealthProfileState extends State<HealthProfile> {
  // final _key =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        child: ListView(
          children: [
            TextFormField(),
            TextFormField(),
            dropDown(),
            // dropDown(),
            // dropDown(),
            // dropDown(),
            // dropDown(),
          ],
        ),
      ),
    );
  }

  dropDown() => FormBuilderDropdown(
        name: 'country',
        decoration: InputDecoration(
          prefixIcon: prefixIcon(Icons.person),
          labelText: 'Country',
        ),
        allowClear: true,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        items: ['countries', 'ascas', 'casasc', 'casca']
            .map((country) => DropdownMenuItem<String>(
                  // value: country.id,
                  child: Text(country),
                ))
            .toList(),
        onSaved: (value) {
          setState(() {});
        },
      );

  prefixIcon(IconData icon) => Icon(icon, color: CustomColors.blue);
}
