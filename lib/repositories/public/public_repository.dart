import 'package:dio/dio.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';

class PublicRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<void> getSpcializations() async {
    Response response = await _apiBaseHelper.getHTTP('specializations');
    SharedPrefrencesHelper.setSpecializations(response.data);
  }

  Future<void> getCountries() async {
    Response response = await _apiBaseHelper.getHTTP('countries');
    SharedPrefrencesHelper.storeCountries(response.data);
  }
}
