import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class CustomThemes extends ChangeNotifier {
  static bool _isDark = false;

  Future<ThemeMode> get currentTheme async {
    _isDark = await SharedPrefrencesHelper.getTheme;
    if (_isDark) return ThemeMode.dark;
    return ThemeMode.light;
  }

  void changeTheme() async {
    _isDark = !_isDark;
    await SharedPrefrencesHelper.setTheme(_isDark);
    notifyListeners();
  }

  bool get isDark => _isDark;

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: CustomColors.blue,
        scaffoldBackgroundColor: CustomColors.white,
        fontFamily: 'Exo',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: CustomColors.blue, fontSize: 24),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
          headline5: TextStyle(
            color: Colors.blueAccent,
          ),
          headline4: TextStyle(
            color: CustomColors.blue,
            height: 2.5,
          ),
          bodyText1: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CustomColors.orange,
          ),
          caption: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            primary: CustomColors.blue,
          ),
        ),
        iconTheme: IconThemeData(color: CustomColors.orange));
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: CustomColors.blue,
      scaffoldBackgroundColor: CustomColors.black,
      fontFamily: 'Exo',
      colorScheme: ColorScheme.dark(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          primary: CustomColors.orange,
        ),
      ),
    );
  }
}
