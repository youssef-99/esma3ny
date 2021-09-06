import 'package:dio/dio.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/public/available_time_slot_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';

class PublicRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<void> getSpcializations() async {
    Response response = await _apiBaseHelper.getHTTP('specializations');
    SharedPrefrencesHelper.setSpecializations(response.data);
  }

  Future<void> getLanguages() async {
    Response response = await _apiBaseHelper.getHTTP('languages');
    SharedPrefrencesHelper.setLanguages(response.data);
  }

  Future<void> getCountries() async {
    Response response = await _apiBaseHelper.getHTTP('countries');
    SharedPrefrencesHelper.storeCountries(response.data);
  }

  Future<void> getJob() async {
    Response response = await _apiBaseHelper.getHTTP('jobs');
    SharedPrefrencesHelper.setJob(response.data);
  }

  Future<List<AvailableTimeSlotResponse>> showTherapistTimeSlots(
      int id, String date) async {
    Response response =
        await _apiBaseHelper.getHTTP('doctor/$id/timeslots?day=$date');

    List<AvailableTimeSlotResponse> list = [];

    if (!response.data.isEmpty)
      response.data.forEach((day, timeslot) =>
          list.add(AvailableTimeSlotResponse.fromJson(day, timeslot)));
    return list;
  }

  Future<void> sendChatMessage(
      int sessionId, String roomId, String message) async {
    await _apiBaseHelper.postHTTP(
      'patient/rooms/$sessionId-$roomId/message',
      {'message': message},
    );
  }

  Future<dynamic> getSessionPics(id, token, uid) async {
    print('patient/rooms/$id-$token/user/$uid');
    Response response =
        await _apiBaseHelper.getHTTP('patient/rooms/$id-$token/user/$uid');
    return response.data;
  }
}
