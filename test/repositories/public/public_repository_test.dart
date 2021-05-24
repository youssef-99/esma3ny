import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/public/available_time_slot_response.dart';
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

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test(
    'time slot',
    () async {
      List<AvailableTimeSlotResponse> list =
          await publicRepository.showTherapistTimeSlots(1, '2021-05-24');
      print(list.first.timeSlots.first.duration);
    },
  );
}
