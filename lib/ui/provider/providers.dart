import 'package:esma3ny/ui/provider/edit_profile_state.dart';
import 'package:esma3ny/ui/provider/filters_state.dart';
import 'package:esma3ny/ui/provider/language_state.dart';
import 'package:esma3ny/ui/provider/login_state.dart';
import 'package:esma3ny/ui/provider/signup_form_state.dart';
import 'package:esma3ny/ui/provider/therapist_profile_state.dart';
import 'package:esma3ny/ui/provider/upcoming_sessions_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'roleState.dart';
import '../theme/theme.dart';

class Providers {
  static List<SingleChildWidget> get proidvers => [
        ChangeNotifierProvider(
          create: (context) => CustomThemes(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => LocalizationState(),
        // ),
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
          create: (context) => TherapistProfileState(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterState(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageState(),
        )
      ];
}
