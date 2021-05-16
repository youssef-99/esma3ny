import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_filter.dart';

abstract class ClientRepository {
  Future<void> login(String email, String pass);
  Future<void> signup(ClientModel clientModel);
  Future<void> logout();
  Future<ClientModel> getProfile();
  Future<void> updateProfile(ClientModel client);
  Future<void> getDoctorsList(FilterTherapist filterTherapist, int pageKey);
  Future<void> getDoctorInfo(int id);
  Future<void> bookNow();
  Future<void> bookLater();
  Future<void> showReservedTimeSlots(int pageKey);
  Future<void> cancelSession(int id);
  Future<void> rescheduleSession(int oldSessionId, int newSeesionId);
}
