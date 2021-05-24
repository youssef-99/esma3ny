import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class SessionBookingReview extends StatefulWidget {
  @override
  _SessionBookingReviewState createState() => _SessionBookingReviewState();
}

class _SessionBookingReviewState extends State<SessionBookingReview> {
  bool payLater = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customListTile('Your Therapist', 'Youssef William'),
          customListTile('Session Type', '30 Min Caht'),
          customListTile('Session Fees', '300 EGP'),
          customListTile('Date', '16-6-2021'),
          customListTile('Time', '6:00 PM'),
          payState(),
          ElevatedButton(onPressed: () {}, child: Text('Confirm'))
        ],
      ),
    );
  }

  customListTile(String leading, String title) => ListTile(
        minLeadingWidth: 100,
        leading: Text(
          '$leading:',
          style: TextStyle(color: CustomColors.orange),
        ),
        title: Text(
          title,
          style: TextStyle(color: CustomColors.blue),
        ),
      );

  payState() => CheckboxListTile(
      title: Text('Pay Later'),
      value: payLater,
      onChanged: (value) => setState(() {
            payLater = value;
          }));
}
