import 'dart:async';

import 'package:dio/dio.dart';

class NetworkConnectionException implements Exception {}

class InvalidData implements Exception {
  Map<String, dynamic> _errors;

  InvalidData(this._errors);

  Map<String, dynamic> get errors => this._errors;
}

class ServerError implements Exception {}

class SomeThingWentWrong implements Exception {}

class ExceptionHandling {
  static handleDioExceprion(DioError e) {
    if (e.type == DioErrorType.other)
      throw NetworkConnectionException();
    else if (e.type == DioErrorType.response) {
      if (e.response.statusCode >= 400 && e.response.statusCode < 500) {
        print(e.response.data);
        throw InvalidData(e.response.data['errors']);
      }
      if (e.response.statusCode >= 500) {
        print(e.response.data);
        throw ServerError();
      }
    } else if (e.type == DioErrorType.connectTimeout) {
      throw TimeoutException('timw out');
    }

    print(e.error);
    throw SomeThingWentWrong();
  }
}
