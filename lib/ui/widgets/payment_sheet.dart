import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentSheet extends StatefulWidget {
  final int timeSlotId;
  PaymentSheet({this.timeSlotId});
  @override
  State<StatefulWidget> createState() {
    return PaymentSheetState();
  }
}

class PaymentSheetState extends State<PaymentSheet> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreditCard testCard;

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_vs2mJM5i18UsWUw58nkhYNK6004VW6Y7YE",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  void setError(error) {
    Fluttertoast.showToast(msg: '${error.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
            ),
            CreditCardForm(
              formKey: formKey,
              obscureCvv: true,
              obscureNumber: true,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              cardHolderName: cardHolderName,
              expiryDate: expiryDate,
              themeColor: Colors.blue,
              cardNumberDecoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: 'Number',
                hintText: 'XXXX XXXX XXXX XXXX',
                labelStyle: TextStyle(color: Colors.blue),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              expiryDateDecoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: 'Expired Date',
                labelStyle: TextStyle(color: Colors.blue),
                hintText: 'MM/YY',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              cvvCodeDecoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelText: 'CVV',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'XXX',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              cardHolderDecoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelStyle: TextStyle(color: Colors.blue),
                labelText: 'Card Holder',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onCreditCardModelChange: onCreditCardModelChange,
            ),
            Consumer<BookSessionState>(
              builder: (context, state, child) => state.loading
                  ? CircularProgressIndicator()
                  : Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'halter',
                                  fontSize: 14,
                                  package: 'flutter_credit_card',
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  testCard = CreditCard(
                                    number: cardNumber,
                                    expMonth:
                                        int.parse(expiryDate.split('/')[0]),
                                    expYear:
                                        int.parse(expiryDate.split('/')[1]),
                                  );

                                  StripePayment.createTokenWithCard(
                                    testCard,
                                  ).then((token) async {
                                    state.setStripeToken(token);

                                    if (widget.timeSlotId != null) {
                                      await state.payNow(widget.timeSlotId);
                                      Navigator.pop(context);
                                    } else
                                      await state.reserveNewSession(false);

                                    if (state.isPaid)
                                      Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              'Bottom_Nav_Bar'));
                                  }).catchError(setError);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
