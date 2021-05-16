import 'package:dio/dio.dart';
import 'package:esma3ny/core/device_info/device_info.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';

class TherapistRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  final _route = 'doctor';

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

  Future<void> signup(Therapist therapist) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/auth/register', therapist.toJsonSignup());

    await SharedPrefrencesHelper.storeToken(response.data['token']);
  }
}
