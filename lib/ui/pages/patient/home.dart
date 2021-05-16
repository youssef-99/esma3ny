import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/colors.dart';

class HomeClient extends StatefulWidget {
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  double _animatedHeight = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(context),
    );
  }

  appBar(context) => AppBar(
        title: Text(
          'HOME',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      );

  body(context) => Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  welcomeText(context),
                  logo(),
                ],
              ),
              firstSesstionMess(context),
              howToBook(),
            ],
          ),
        ),
      );

  welcomeText(context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.headline4,
          children: <TextSpan>[
            TextSpan(text: 'Hello '),
            TextSpan(
              text: 'Youssef',
              style: TextStyle(color: CustomColors.orange),
            ),
          ],
        ),
      );

  logo() => SvgPicture.asset(
        'assets/images/ear.svg',
      );

  firstSesstionMess(context) => Material(
        borderRadius: BorderRadius.circular(50),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            'YOUR 1ST SESSION IS A FREE 30 MINUTE INTAKE SESSION',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
      );

  howToBook() => InkWell(
        onTap: () {
          setState(() {
            _animatedHeight != 20.0
                ? _animatedHeight = 20.0
                : _animatedHeight = 40.0;
          });
        },
        child: AnimatedContainer(
            curve: Curves.bounceIn,
            duration: Duration(seconds: 1),
            width: MediaQuery.of(context).size.width * 0.8,
            height: _animatedHeight,
            decoration: BoxDecoration(
              color: CustomColors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text('hi')),
      );
}
