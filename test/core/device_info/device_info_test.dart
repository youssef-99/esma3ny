import 'package:esma3ny/core/device_info/device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return device info',
    () async {
      final result = await getDeviceName();
      print(result);
    },
  );
}
