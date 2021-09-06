import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/public/country.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClientRepositoryImpl extends Mock implements ClientRepositoryImpl {}

class MockApiBaseHelper extends Mock implements ApiBaseHelper {}

void main() {
  PublicRepository publicRepository = PublicRepository();
  ClientRepositoryImpl clientRepositoryImpl = ClientRepositoryImpl();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test(
    'akcjnkasncajnsckajnsckasncknakcjns',
    () async {
      await clientRepositoryImpl.login(
          'youssefwilliam970@gmail.com', '123456%');
      dynamic asd = await publicRepository.getSessionPics(
          '8', '9451a404-cdc1-44e9-9cc6-27223b30662b', 21);
      print(asd);
    },
  );
}
