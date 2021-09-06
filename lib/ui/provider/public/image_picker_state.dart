import 'dart:io';

import 'package:dio/dio.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerState extends ChangeNotifier {
  File file;
  final picker = ImagePicker();
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  pick(id, uuid) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      Response response = await _apiBaseHelper.postPhotoHTTP(
        'patient/rooms/$id-$uuid/message',
        {
          'attachment': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        },
      );
      print(response.data);
    } else {
      // User canceled the picker
    }
  }
}
