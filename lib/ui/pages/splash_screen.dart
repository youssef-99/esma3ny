import 'dart:async';

import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  var _tween;
  bool isDone = false;
  PublicRepository _publicRepository = PublicRepository();
  bool isLoggedClient = false;
  bool isLoggedTherapist = false;
  String role;

  _getCountries() async {
    try {
      await _publicRepository.getCountries();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occured check your internet connection',
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
      );
    }
  }

  _checkLogging() async {
    role = await SharedPrefrencesHelper.isLogged();
    print(role);
    isLoggedClient = role == CLIENT;
    isLoggedTherapist = role == THERAPIST;
  }

  @override
  void initState() {
    _getCountries();
    _checkLogging();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _tween = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    Timer(Duration(seconds: 4), () {
      setState(() {
        isDone = true;
      });
    });

    Timer(Duration(seconds: 5), () {
      if (isLoggedClient)
        Navigator.pushReplacementNamed(context, 'Bottom_Nav_Bar');
      else if (isLoggedTherapist)
        Navigator.pushReplacementNamed(context, 'Bottom_Nav_Bar_therapist');
      else
        Navigator.pushReplacementNamed(context, 'login');
    });

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: decorationImage('assets/images/splash-bg.png'),
          ),
          Hero(
            tag: 'logo',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: _tween.value * 150,
                  height: _tween.value * 150,
                  // decoration: decorationImage('assets/images/ear.png'),
                  child: SvgPicture.asset(
                    'assets/images/ear.svg',
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/esma3ny.svg',
                ),
                SizedBox(
                  height: 20,
                ),
                Opacity(
                  opacity: _animationController.value,
                  child: SvgPicture.asset(
                    'assets/images/you_talk.svg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  decorationImage(String imageBundle) => BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(imageBundle),
        ),
      );
}
