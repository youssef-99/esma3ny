import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static hanleToastException(Function function) async {
    try {
      await function();
      Fluttertoast.showToast(
          msg: 'Session Booked Successfully', backgroundColor: Colors.green);
    } on InvalidData catch (_) {
      Fluttertoast.showToast(msg: 'Invaild Data');
    } on NetworkConnectionException catch (_) {
      Fluttertoast.showToast(
          msg: 'Network error check your internet exception');
    } on TimeoutException catch (_) {
      Fluttertoast.showToast(msg: 'Time out');
    } on ServerError catch (_) {
      Fluttertoast.showToast(msg: 'Server Error');
    } on SomeThingWentWrong catch (_) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
}
