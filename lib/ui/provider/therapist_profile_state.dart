import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:flutter/material.dart';

class TherapistProfileState extends ChangeNotifier {
  int _id;
  String country;

  getCounry(int id) async {
    country = await SharedPrefrencesHelper.getCountryName(id);
    return country;
  }

  setId(int id) {
    this._id = id;
  }

  int get id => _id;
}
