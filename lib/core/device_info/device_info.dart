import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
String deviceData;

Future<String> getDeviceName() async {
  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } on PlatformException {
    deviceData = 'Failed to get platform version.';
  }
  return deviceData;
}

String _readAndroidBuildData(AndroidDeviceInfo build) {
  return build.model;
}

String _readIosDeviceInfo(IosDeviceInfo build) {
  return build.model;
}
