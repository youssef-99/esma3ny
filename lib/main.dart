import 'package:esma3ny/ui/pages/comming_soon.dart';
import 'package:esma3ny/ui/pages/doctor/add_certificate.dart';
import 'package:esma3ny/ui/pages/doctor/add_education.dart';
import 'package:esma3ny/ui/pages/doctor/add_excperience.dart';
import 'package:esma3ny/ui/pages/doctor/bottom_nav_bar.dart';
import 'package:esma3ny/ui/pages/doctor/edit_about_me.dart';
import 'package:esma3ny/ui/pages/doctor/edit_basic_info.dart';
import 'package:esma3ny/ui/pages/doctor/edit_session_fees.dart';
import 'package:esma3ny/ui/pages/doctor/profile.dart';
import 'package:esma3ny/ui/pages/doctor/session_history.dart';
import 'package:esma3ny/ui/pages/doctor/session_notes.dart';
import 'package:esma3ny/ui/pages/patient/Profile.dart';
import 'package:esma3ny/ui/pages/patient/edit_profile_page.dart';
import 'package:esma3ny/ui/pages/patient/health_profile.dart';
import 'package:esma3ny/ui/pages/patient/session_history.dart';
import 'package:esma3ny/ui/pages/patient/therapist_profile_page.dart';
import 'package:esma3ny/ui/provider/public/language_state.dart';
import 'package:esma3ny/ui/widgets/payment_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/localization/form_builder_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'ui/pages/auth/login.dart';
import 'ui/pages/auth/signup.dart';
import 'ui/pages/patient/bottomNavBar.dart';
import 'ui/pages/splash_screen.dart';
import 'ui/theme/theme.dart';
import 'ui/provider/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // await initializeDateFormatting();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) =>
    MultiProvider(
      providers: Providers.proidvers,
      child: MyApp(),
    ),
    // ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Provider.of<LanguageState>(context, listen: false).setLocale();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageState, CustomThemes>(
      builder: (context, locale, themeState, child) {
        return FutureBuilder(
          future: themeState.currentTheme,
          builder: (context, snapshot) => MaterialApp(
            // locale: DevicePreview., // Add the locale here
            // builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              FormBuilderLocalizations.delegate,
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // English, no country code
              const Locale('ar', 'SA'), // Arabic, no country code
            ],
            locale: locale.currentLocale,
            title: 'Esma3ny',
            theme: CustomThemes.lightTheme,
            darkTheme: CustomThemes.darkTheme,
            themeMode: snapshot.hasData ? snapshot.data : ThemeMode.light,
            // initialRoute: 'session_notes',
            routes: {
              '/': (context) => SplashScreen(),
              'login': (context) => Login(),
              'signup': (context) => Signup(),
              'Bottom_Nav_Bar': (context) => BottomNavBar(),
              'comming_soon': (context) => CommingSoon(),
              'edit_profile': (context) => EditProfilePage(),
              'therapist_profile': (context) => TherapistProfile(),
              'client_profile': (context) => Profile(),
              'payment_sheet': (context) => PaymentSheet(),
              'session_history': (context) => SessionHistory(),
              'health_profile': (context) => HealthProfile(),
              'therapist_profile_page': (context) => TherapistProfilePage(),
              'Bottom_Nav_Bar_therapist': (context) => TherapistBottomNavBar(),
              'edit_therapist_bais_info': (context) => EditBasicInfoPage(),
              'edit_about_me_page': (context) => EditAboutMePage(),
              'therapist_session_history': (context) => SessionHistoryPage(),
              'edit_session_fees': (context) => EditSessionFees(),
              'add_experience': (context) => AddExperience(),
              'add_certificate': (context) => AddCertificate(),
              'add_education': (context) => AddEducation(),
              'session_notes': (context) => SessionNotes(),
            },
          ),
        );
      },
    );
  }
}
