import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TherapistRepository therapistRepository = TherapistRepository();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUp(() {});

  group('api', () {
    test(
      'should login with right creditials',
      () async {
        await therapistRepository.login(
            'youssefwilliam2311@gmail.com', '123456%');
      },
    );

    test(
      'should login with right creditials',
      () async {
        List<int> spe = [1, 2];
        List<int> main = [0, 1];
        await therapistRepository.updateSpeciality(spe, main);
      },
    );
  });
}
