import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NetworkConnectionException implements Exception {}

class InvalidData implements Exception {
  Map<String, dynamic> _errors;
  String msg;
  int statusCode;

  InvalidData(
    this._errors, {
    this.msg,
    this.statusCode,
  });

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
        throw InvalidData(e.response.data['errors'],
            msg: e.response.data['msg'], statusCode: e.response.statusCode);
      }
      if (e.response.statusCode >= 500) {
        print(e.response.data);
        throw ServerError();
      }
    } else if (e.type == DioErrorType.connectTimeout) {
      throw TimeoutException('time out');
    }

    print(e.error);
    throw SomeThingWentWrong();
  }

  static hanleToastException(
      Function function, String doneMessage, bool isShow) async {
    try {
      await function();
      if (isShow)
        Fluttertoast.showToast(
          msg: doneMessage,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 4,
        );
    } on InvalidData catch (e) {
      Fluttertoast.showToast(
          msg: e.msg, timeInSecForIosWeb: 4, backgroundColor: Colors.red);
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
