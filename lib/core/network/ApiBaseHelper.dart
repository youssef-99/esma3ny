// import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/core/network/networkInfo.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';

class ApiBaseHelper {
  static final String url = 'https://esma3ny.org/api/';
  static BaseOptions opts = BaseOptions(
      baseUrl: url,
      responseType: ResponseType.json,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Accept': 'application/json',
      });

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
            onRequest: (RequestOptions options, handler) =>
                requestInterceptor(options, handler),
            onError: (DioError e, handler) async {
              return handler.next(e);
            }),
      );
  }

  static dynamic requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    DataConnectionChecker dataConnectionChecker = DataConnectionChecker();
    NetworkInfoImpl networkInfoImpl = NetworkInfoImpl(dataConnectionChecker);
    if (!await networkInfoImpl.isConnected) {
      handler
          .reject(DioError(requestOptions: options, type: DioErrorType.other));
    }

    // Get your JWT token
    final token = await SharedPrefrencesHelper.getToken;
    if (token != null) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer ' + token;
    }
    return handler.next(options);
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  // ignore: missing_return
  Future<Response> getHTTP(String url) async {
    try {
      Response response = await baseAPI.get(url);
      return response;
    } on DioError catch (e) {
      ExceptionHandling.handleDioExceprion(e);
    }
  }

  // ignore: missing_return
  Future<Response> postHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.post(url, data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      ExceptionHandling.handleDioExceprion(e);
    }
  }

  // ignore: missing_return
  Future<Response> postPhotoHTTP(String url, dynamic data) async {
    try {
      FormData formData = FormData.fromMap(data);
      Response response = await baseAPI.post(url, data: formData);
      return response;
    } on DioError catch (e) {
      print(e);
      ExceptionHandling.handleDioExceprion(e);
    }
  }

  // ignore: missing_return
  Future<Response> putHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.put(url, data: data);
      return response;
    } on DioError catch (e) {
      ExceptionHandling.handleDioExceprion(e);
    }
  }

  // ignore: missing_return
  Future<Response> deleteHTTP(String url) async {
    try {
      Response response = await baseAPI.delete(url);
      return response;
    } on DioError catch (e) {
      ExceptionHandling.handleDioExceprion(e);
    }
  }
}
