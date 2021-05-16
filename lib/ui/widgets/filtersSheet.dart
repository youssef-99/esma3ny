import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/constant.dart';
import 'customDatePicker.dart';

class FilterSheet extends StatefulWidget {
  final _dateController;
  FilterSheet(this._dateController);
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DateTime selectedDate = DateTime.now();
  bool label = false;
  int genderTag = 1;
  int feesTag = 1;
  List<String> tags = [];
  List<String> genders = ['other', 'male', 'female'];
  List<String> fees = [
    'any',
    'less 150',
    '150-200',
    '200-300',
    '300-500',
    'above 500'
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filters',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: CustomColors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            dropDownFilterColumn(Icons.apps, 'Specialization'),
            dropDownFilterColumn(Icons.public, 'Languanges'),
            group(
              listTile(Icons.watch_later, 'Availability'),
              datePicker(),
            ),
            group(
              listTile(Icons.person, 'Gender'),
              genderChip(),
            ),
            group(
              listTile(Icons.attach_money_outlined, 'Fees'),
              feesChip(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: null, child: Text('Resset')),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(onPressed: null, child: Text('Apply'))
              ],
            )
          ],
        ),
      ),
    );
  }

  dropDownFilterColumn(IconData icon, String title) => Column(
        children: [
          listTile(icon, title),
          dropDownButton(),
        ],
      );

  group(Widget header, Widget content) => Column(
        children: [
          header,
          content,
        ],
      );

  // for titles
  listTile(IconData icon, String title) => Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(
            title,
            style: kFiltersTextTheme,
          ),
        ],
      );

  // adjust padding for the pickers
  padding(Widget child) => Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: child,
          )
        ],
      );

  dropDownButton() => padding(
        DropdownButtonFormField<String>(
          hint: Text('Select Specialization'),
          items: <String>['A', 'B', 'C', 'D'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      );

  datePicker() => padding(CustomDatePicker(widget._dateController));

  genderChip() => Align(
        alignment: Alignment.center,
        child: ChipsChoice<int>.single(
          value: genderTag,
          onChanged: (val) => setState(() {
            genderTag = val;
            print(val);
          }),
          choiceItems: C2Choice.listFrom<int, String>(
              source: genders,
              value: (i, v) => i,
              label: (i, v) => v,
              tooltip: (i, v) => v,
              style: (i, v) {
                return C2ChoiceStyle(
                  labelStyle: TextStyle(fontSize: 18),
                );
              }),
          choiceActiveStyle: C2ChoiceStyle(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: CustomColors.orange,
          ),
          wrapped: true,
        ),
      );

  feesChip() => Align(
        alignment: Alignment.center,
        child: ChipsChoice<int>.single(
          value: feesTag,
          onChanged: (val) => setState(() {
            feesTag = val;
            print(val);
          }),
          choiceItems: C2Choice.listFrom<int, String>(
              source: fees,
              value: (i, v) => i,
              label: (i, v) => v,
              tooltip: (i, v) => v,
              style: (i, v) {
                return C2ChoiceStyle(labelStyle: TextStyle(fontSize: 18));
              }),
          choiceActiveStyle: C2ChoiceStyle(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: CustomColors.orange,
          ),
          wrapped: true,
        ),
      );
}
