import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:flutter/material.dart';

class ClientTherapistProfileState extends ChangeNotifier {
  int _id;
  String country;
  ClientModel _clientModel;

  getCounry(int id) async {
    country = await SharedPrefrencesHelper.getCountryName(id);
    return country;
  }

  setClient(ClientModel client) {
    _clientModel = client;
  }

  setId(int id) {
    this._id = id;
  }

  ClientModel get client => _clientModel;
  int get id => _id;
}
