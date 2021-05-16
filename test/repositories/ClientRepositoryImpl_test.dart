import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClientRepositoryImpl extends Mock implements ClientRepositoryImpl {}

class MockApiBaseHelper extends Mock implements ApiBaseHelper {}

void main() {
  ClientRepositoryImpl clientRepositoryImpl = ClientRepositoryImpl();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUp(() {});

  group(
    'login',
    () {
      test(
        'should login with right creditials',
        () async {
          await clientRepositoryImpl.login(
              'youssefwilliam970@gmail.com', '123456%');
        },
      );

      // test(
      //   'signup',
      //   () async {
      //     Client client = Client(
      //       name: 'you',
      //       email: 'you@gmail.com',
      //       phone: '01141836675',
      //       password: '123456',
      //       confirmPassword: '123456',
      //       gender: 'male',
      //       deviceName: 'ac;s,',
      //       dateOfBirth: '',
      //       countryId: '62',
      //     );
      //     await clientRepositoryImpl.signup(client);
      //   },
      // );

      // test(
      //   'get profile',
      //   () async {
      //     Client client = await clientRepositoryImpl.getProfile();
      //     print(client.email);
      //   },
      // );

      // test('updateProfile', () async {
      //   Client client = Client(
      //     name: 'namee',
      //     email: 'youssefwilliam970@gmail.com',
      //     phone: '12315646879',
      //     gender: 'male',
      //     dateOfBirth: '1999-06-01',
      //     countryId: '62',
      //   );

      // await clientRepositoryImpl.updateProfile(client);
      // });
    },
  );
}
