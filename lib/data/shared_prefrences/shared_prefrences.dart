import 'dart:convert';

import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesHelper {
  static setLanguage(isEnglish) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isEnglish', isEnglish);
  }

  static setLoginData(Map<String, dynamic> loginResponse) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String encodedResponse = json.encode(loginResponse);
    await sharedPreferences.setBool('logged', true);
    await sharedPreferences.setString('loginResponse', encodedResponse);
  }

  static Future<LoginResponse> getLoginData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> decodedResponse =
        json.decode(sharedPreferences.getString('loginResponse'));

    LoginResponse loginResponse = LoginResponse.fromJson(decodedResponse);
    return loginResponse;
  }

  static Future<bool> isLogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('logged');
  }

  static get getLocale async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isEnglish') == null
        ? true
        : sharedPreferences.getBool('isEnglish');
  }

  static setTheme(isDark) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('theme', isDark);
  }

  static get getTheme async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('theme') == null
        ? false
        : sharedPreferences.getBool('theme');
  }

  static storeToken(String token) async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', token);
  }

  static get getToken async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }

  static storeCountries(List<dynamic> countries) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedCountries = json.encode(countries);
    await sharedPreferences.setString('countries', encodedCountries);
  }

  static Future<List<Country>> get getCountries async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedCountries =
        jsonDecode(sharedPreferences.getString('countries'));
    List<Country> countries = [];
    encodedCountries
        .forEach((country) => countries.add(Country.fromJson(country)));
    return countries;
  }

  static Future<String> getCountryName(int id) async {
    List<Country> countries = await getCountries;
    return countries[id - 1].name;
  }

  static Future<void> setSpecializations(List<dynamic> specializations) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedSpcializations = jsonEncode(specializations);
    await sharedPreferences.setString('specializations', encodedSpcializations);
  }

  static Future<List<Specialization>> get getSpecializations async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedspecializations =
        jsonDecode(sharedPreferences.getString('specializations'));
    List<Specialization> specializations = [];
    encodedspecializations.forEach((specialization) =>
        specializations.add(Specialization.fromJson(specialization)));
    return specializations;
  }

  static Future<void> setLanguages(List<dynamic> languages) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedLanguages = jsonEncode(languages);
    await sharedPreferences.setString('language', encodedLanguages);
  }

  static Future<List<Language>> get getLanguages async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedLanguages =
        jsonDecode(sharedPreferences.getString('language'));
    List<Language> languages = [];
    encodedLanguages
        .forEach((language) => languages.add(Language.fromJson(language)));
    return languages;
  }

  static Future<void> setJob(List<dynamic> jobs) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedJobs = jsonEncode(jobs);
    await sharedPreferences.setString('jobs', encodedJobs);
  }

  static Future<List<Job>> get job async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedjob = jsonDecode(sharedPreferences.getString('jobs'));
    List<Job> jobs = [];
    encodedjob.forEach((job) => jobs.add(Job.fromJson(job)));
    return jobs;
  }

  static Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    sharedPreferences.remove('loginResponse');
  }
}
