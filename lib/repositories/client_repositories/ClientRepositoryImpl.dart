import 'dart:async';

import 'package:dio/dio.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_filter.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';

import '../../core/device_info/device_info.dart';
import '../../data/shared_prefrences/shared_prefrences.dart';
import 'ClientRepository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final String _route = 'patient';
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  @override
  Future<dynamic> login(String email, String pass) async {
    final deviceName = await getDeviceName();

    Map<String, dynamic> creditials = {
      'email': email,
      'password': pass,
      'device_name': deviceName,
    };

    Response response = await _apiBaseHelper.postHTTP(
      '$_route/auth/login',
      creditials,
    );

    await SharedPrefrencesHelper.storeToken(response.data['token']);

    return response;
  }

  @override
  Future<void> signup(ClientModel client) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/auth/register', client.toJsonSignup());

    await SharedPrefrencesHelper.storeToken(response.data['token']);
  }

  @override
  Future<void> bookLater() {
    // TODO: implement bookLater
    throw UnimplementedError();
  }

  @override
  Future<void> bookNow() {
    // TODO: implement bookNow
    throw UnimplementedError();
  }

  @override
  Future<Therapist> getDoctorInfo(int id) async {
    Response response = await _apiBaseHelper.getHTTP('doctor/$id');
    return Therapist.fromJson(response.data);
  }

  @override
  Future<dynamic> getDoctorsList(
      FilterTherapist filterTherapist, int pageKey) async {
    Response response = await _apiBaseHelper.postHTTP(
        'doctors-list/search?page=$pageKey', filterTherapist.toJson());
    return response.data;
  }

  @override
  Future<ClientModel> getProfile() async {
    Response response = await _apiBaseHelper.getHTTP('$_route/auth/me');
    return ClientModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async =>
      await _apiBaseHelper.postHTTP('$_route/auth/logout', null);

  @override
  Future<void> updateProfile(ClientModel client) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/profile/update', client.toJsonEdit());
    print(response.data);
  }

  @override
  Future<dynamic> showReservedTimeSlots(int pageKey) async {
    Response response =
        await _apiBaseHelper.getHTTP('$_route/timeslots?page=$pageKey');
    return response.data;
  }

  @override
  Future<String> cancelSession(int id) async {
    Response response =
        await _apiBaseHelper.deleteHTTP('$_route/timeslots/$id');
    return response.data['msg'];
  }

  @override
  Future<void> rescheduleSession(int oldSessionId, int newSeesionId) {
    // TODO: implement rescheduleSession
    throw UnimplementedError();
  }
}