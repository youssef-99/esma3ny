import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CountryList extends StatefulWidget {
  final name;
  final Function onChange;
  final List<Country> countries;
  const CountryList({
    Key key,
    @required this.name,
    @required this.onChange,
    @required this.countries,
  }) : super(key: key);
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: widget.name,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.home, color: CustomColors.blue),
        labelText: widget.name,
      ),
      allowClear: true,
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(context)]),
      items: widget.countries
          .map((element) => DropdownMenuItem<int>(
                value: element.id,
                child: Text(element.name),
              ))
          .toList(),
      onChanged: (val) => widget.onChange(val),
    );
  }
}
