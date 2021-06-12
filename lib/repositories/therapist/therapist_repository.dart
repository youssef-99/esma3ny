import 'package:dio/dio.dart';
import 'package:esma3ny/core/device_info/device_info.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/public/certificate.dart';
import 'package:esma3ny/data/models/public/education.dart';
import 'package:esma3ny/data/models/public/experience.dart';
import 'package:esma3ny/data/models/therapist/Therapist.dart';
import 'package:esma3ny/data/models/therapist/therapist_profile_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:http_parser/http_parser.dart';

class TherapistRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  final _route = 'doctor';

  Future<dynamic> login(String email, String pass) async {
    final deviceName = await getDeviceName();

    Map<String, dynamic> creditials = {
      'email': email,
      'password': pass,
      'device_name': 'deviceName',
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

  Future<TherapistProfileResponse> getProfile() async {
    Response response = await _apiBaseHelper.getHTTP('$_route/auth/me');
    TherapistProfileResponse therapistProfileResponse =
        TherapistProfileResponse.fromJson(response.data);
    return therapistProfileResponse;
  }

  Future<String> updateSpeciality(
      List<int> specialities, List<int> mainFocus) async {
    Response response = await _apiBaseHelper
        .postHTTP('$_route/profile/specializations/update', {
      'specializations': specialities,
      'main_focus': mainFocus,
    });
    return response.data['msg'];
  }

  Future<String> addExperience(Experience experience) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/profile/experiences', experience.toJson());

    return response.data['msg'];
  }

  Future<String> addEducation(Education education) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/profile/educations', education.toJson());

    return response.data['msg'];
  }

  Future<String> addCertificate(Certificate certificate) async {
    Response response = await _apiBaseHelper.postHTTP(
        '$_route/profile/experiences', certificate.toJson());

    return response.data['msg'];
  }

  Future<void> updateBasicInfo(Therapist therapist) async {
    Response response =
        await _apiBaseHelper.postHTTP('$_route', therapist.toJsonUpdate());
    print(response.data);
  }

  Future<void> uploadProfilePic(String imagePath, Therapist therapist) async {
    Response response = await _apiBaseHelper.postPhotoHTTP('$_route', {
      ...therapist.toJsonUpdate(),
      'image': await MultipartFile.fromFile(imagePath,
          filename: imagePath.split('/').last,
          contentType: MediaType('image', 'jpg')),
    });
    print(response.data);
  }
}
