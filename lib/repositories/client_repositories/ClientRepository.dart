import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/client_models/health_profile.dart';
import 'package:esma3ny/data/models/client_models/health_profile_helper.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_filter.dart';
import 'package:esma3ny/data/models/public/session_price_response.dart';

abstract class ClientRepository {
  Future<void> login(String email, String pass);
  Future<void> signup(ClientModel clientModel);
  Future<void> logout();
  Future<ClientModel> getProfile();
  Future<void> updateProfile(ClientModel client);
  Future<void> getDoctorsList(FilterTherapist filterTherapist, int pageKey);
  Future<void> getDoctorInfo(int id);
  Future<dynamic> reserveNewSession(
      int id, String type, bool payLater, String stripeToken);
  Future<void> showReservedTimeSlots(int pageKey);
  Future<void> cancelSession(int id);
  Future<void> rescheduleSession(int oldSessionId, int newSeesionId);
  Future<SessionPriceResponse> getSelectedTimeSlotPrice(int id, String type);
  Future<void> payNow(int id, String stripeToken);
  Future<void> uploadProfilePic(String imagePath, ClientModel client);
  Future<dynamic> getSessionHistory(int pageKey);
  Future<HealthProfileHelper> getHealthProfileHelper();
  Future<String> updateHealthProfile(HealthProfileJson healthProfileJson);
}
