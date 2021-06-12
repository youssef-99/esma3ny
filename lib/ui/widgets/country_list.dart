import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CountryList extends StatefulWidget {
  final name;

  const CountryList({Key key, @required this.name}) : super(key: key);
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  PublicRepository _publicRepository = PublicRepository();

  Future<List<Country>> getCountries() async {
    List<Country> countryList = await SharedPrefrencesHelper.getCountries;

    if (countryList == null) {
      await _publicRepository.getCountries();
      countryList = await SharedPrefrencesHelper.getCountries;
    }

    return countryList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
        future: getCountries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FormBuilderDropdown(
              name: widget.name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.home, color: CustomColors.blue),
                labelText: widget.name,
              ),
              allowClear: true,
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required(context)]),
              items: snapshot.data
                  .map((element) => DropdownMenuItem<String>(
                        value: element.id.toString(),
                        child: Text(element.name),
                      ))
                  .toList(),
              onSaved: (value) {
                setState(() {});
              },
            );
          }
          return SizedBox();
        });
  }
}
