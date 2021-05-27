import 'package:esma3ny/data/models/public/session_price_response.dart';
import 'package:esma3ny/data/models/public/time_slot.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/book_session_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/payment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SessionBookingReview extends StatefulWidget {
  final String therapistName;
  final String sessionType;
  final SessionPriceResponse fees;
  final date;
  final TimeSlot timeSlot;

  SessionBookingReview({
    @required this.therapistName,
    @required this.sessionType,
    @required this.fees,
    @required this.date,
    @required this.timeSlot,
  });
  @override
  _SessionBookingReviewState createState() => _SessionBookingReviewState();
}

class _SessionBookingReviewState extends State<SessionBookingReview> {
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  bool payLater = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<BookSessionState>(
      builder: (context, state, child) => Container(
        padding: EdgeInsets.all(10),
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customListTile('Your Therapist', state.therapist.nameEn),
            customListTile('Session Type',
                '${state.selectedTimeSlot.duration} ${state.sessionTypeText}'),
            customListTile('Session Fees',
                '${state.sessionPriceResponse.price} ${state.sessionPriceResponse.currency}'),
            customListTile('Date', state.selectedDate),
            customListTile('Time', state.selectedTimeSlot.startTime),
            payState(),
            state.loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await state.reserveNewSession(payLater);
                      if (!payLater)
                        showMaterialModalBottomSheet(
                            context: context,
                            builder: (_) => PaymentSheetScreen());
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Confirm'))
          ],
        ),
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
