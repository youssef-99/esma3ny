import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/provider/client/chat_state.dart';
import 'package:esma3ny/ui/provider/client/edit_profile_state.dart';
import 'package:esma3ny/ui/provider/client/filters_state.dart';
import 'package:esma3ny/ui/provider/client/health_profile_state.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/provider/public/language_state.dart';
import 'package:esma3ny/ui/provider/public/login_state.dart';
import 'package:esma3ny/ui/provider/public/signup_form_state.dart';
import 'package:esma3ny/ui/provider/client/upcoming_sessions_state.dart';
import 'package:esma3ny/ui/provider/therapist/about_me_state.dart';
import 'package:esma3ny/ui/provider/therapist/add_ceritficate_state.dart';
import 'package:esma3ny/ui/provider/therapist/add_education_state.dart';
import 'package:esma3ny/ui/provider/therapist/add_experience_state.dart';
import 'package:esma3ny/ui/provider/therapist/basic_info_state.dart';
import 'package:esma3ny/ui/provider/therapist/fees_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'public/roleState.dart';
import '../theme/theme.dart';

class Providers {
  static List<SingleChildWidget> get proidvers => [
        ChangeNotifierProvider(
          create: (context) => CustomThemes(),
        ),
        ChangeNotifierProvider(
          create: (context) => RoleState(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignupState(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginState(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditProfileState(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpcommingSessionState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientTherapistProfileState(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterState(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageState(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookSessionState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatState(),
        ),
        ChangeNotifierProvider(
          create: (context) => HealthProfileState(),
        ),
        ChangeNotifierProvider(
          create: (context) => TherapistProfileState(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditBasicInfoState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AboutMeState(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeesState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddExperienceState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddCertificateState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddEducationState(),
        ),
      ];
}
