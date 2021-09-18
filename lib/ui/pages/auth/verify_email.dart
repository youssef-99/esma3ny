import 'package:flutter/material.dart';

class EmailVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thanks for signing up! Before getting started, could you verify your email address by clicking on the link we just emailed to you? If you didn\'t receive the email, we will gladly send you another.',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Resend Verification Email'),
            )
          ],
        ),
      ),
    );
  }
}
