import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/calender.dart';
import 'package:esma3ny/ui/widgets/time_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smart_select/smart_select.dart';

class BookingOptionModalSheet extends StatefulWidget {
  @override
  _BookingOptionModalSheetState createState() =>
      _BookingOptionModalSheetState();
}

class _BookingOptionModalSheetState extends State<BookingOptionModalSheet> {
  String value = 'flutter';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'ion', title: 'Ionic'),
    S2Choice<String>(value: 'flu', title: 'Flutter'),
    S2Choice<String>(value: 'rea', title: 'React Native'),
  ];

  List<bool> tiles = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Today',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Tomorrow',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                  context: context, builder: (context) => Calender());
            },
            child: Text('Or Choose Date'),
          ),
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange,
            ),
            child: ListTile(
              title: Text(
                '1 Jan 2021',
                style: Theme.of(context).textTheme.headline6,
              ),
              leading: Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 300,
            child: FormBuilderRadioGroup(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (value) {},
              options: [
                FormBuilderFieldOption(value: 'Video call'),
                FormBuilderFieldOption(value: 'Voice call'),
                FormBuilderFieldOption(value: 'Chat'),
              ],
              orientation: OptionsOrientation.horizontal,
              name: 'session type',
            ),
          ),
          Container(
            width: 200,
            child: FormBuilderRadioGroup(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10)),
              autovalidateMode: AutovalidateMode.always,
              onChanged: (value) {},
              options: [
                FormBuilderFieldOption(value: '30 Min'),
                FormBuilderFieldOption(value: '60 Min'),
              ],
              orientation: OptionsOrientation.horizontal,
              name: 'session type',
            ),
          ),
          Text(
            'Choose Time',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (context, index) => TimeTile(tiles[index]),
            ),
          ),
          Text(
            '200 LE',
            style: TextStyle(color: Colors.green, fontSize: 20, height: 3),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                'Conintue',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
        ],
      ),
    );
  }
}
