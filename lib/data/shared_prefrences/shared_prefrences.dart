import 'dart:convert';

import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesHelper {
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

  static Future<String> getCountryName(String id) async {
    List<Country> countries = await getCountries;
    return countries[int.parse(id) - 1].name;
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

  static Future<void> setLanguages(List<dynamic> specializations) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedSpcializations = jsonEncode(specializations);
    await sharedPreferences.setString('specializations', encodedSpcializations);
  }
}
