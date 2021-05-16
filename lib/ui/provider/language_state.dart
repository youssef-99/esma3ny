import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:flutter/material.dart';

class LanguageState extends ChangeNotifier {
  Locale _currentLocale;
  bool _isEnglish;
  bool _isArabic;

  Future<void> setLocale() async {
    _isEnglish = await SharedPrefrencesHelper.getLocale;
    if (_isEnglish == null) {
      await SharedPrefrencesHelper.setLanguage(true);
      _isEnglish = true;
      _isArabic = false;
      _currentLocale = Locale('en', 'us');
      notifyListeners();
    } else {
      print(_isEnglish);
      _isArabic = !_isEnglish;
      if (_isEnglish)
        _currentLocale = Locale('en', 'us');
      else
        _currentLocale = Locale('ar', 'su');
      notifyListeners();
    }
  }

  changeLocale() async {
    _isEnglish = !isEnglish;
    _isArabic = !_isArabic;
    if (_currentLocale == Locale('en', 'us'))
      _currentLocale = Locale('ar', 'su');
    else
      _currentLocale = Locale('en', 'us');
    await SharedPrefrencesHelper.setLanguage(_isEnglish);
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;
  bool get isEnglish => _isEnglish;
  bool get isArabic => _isArabic;
}
