import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/about_therapist.dart';
import 'package:esma3ny/ui/widgets/education_and_certificates.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/experience.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:esma3ny/ui/widgets/therapist_fees_list.dart';
import 'package:esma3ny/ui/widgets/therapist_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TherapistProfile extends StatefulWidget {
  @override
  _TherapistProfileState createState() => _TherapistProfileState();
}

class _TherapistProfileState extends State<TherapistProfile>
    with SingleTickerProviderStateMixin {
  TabController controller;
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  int id;

  @override
  void initState() {
    id = Provider.of<ClientTherapistProfileState>(context, listen: false).id;
    controller = TabController(vsync: this, length: 4, initialIndex: 0);
    super.initState();
  }

  getProfile() async {
    ClientModel clientModel = await _clientRepositoryImpl.getProfile();

    Provider.of<ClientTherapistProfileState>(context, listen: false)
        .setClient(clientModel);

    Provider.of<BookSessionState>(context, listen: false)
        .setProfileCompelete(clientModel.profileCompeleted);
  }

  Future<Therapist> getData() async {
    await getProfile();
    Therapist therapist = await _clientRepositoryImpl.getDoctorInfo(id);
    print(id);
    return therapist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).therapist_profile,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CustomProgressIndicator();
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return body(snapshot.data);
            } else if (snapshot.hasError) {
              return errorHandling(snapshot.error);
            }
          }
          return SomethingWentWrongWidget();
        },
      ),
    );
  }

  errorHandling(dynamic error) {
    return ErrorIndicator(
      error: error,
      onTryAgain: () => setState(() {}),
    );
  }

  body(Therapist therapist) => Container(
        child: Column(
          children: [
            TherapistInfoCard(therapist),
            TabBar(
              unselectedLabelColor: CustomColors.lightBlue,
              labelColor: CustomColors.blue,
              controller: controller,
              tabs: [
                tabText(AppLocalizations.of(context).about),
                tabText(AppLocalizations.of(context).experience),
                tabText(AppLocalizations.of(context).education),
                tabText(AppLocalizations.of(context).fees),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  AbouTherapist(therapist),
                  therapist.experience.isEmpty
                      ? Center(
                          child: Text(AppLocalizations.of(context).no_ex_found),
                        )
                      : Experience(therapist),
                  EducationAndCertificate(therapist),
                  TherapistFeesList(therapist.fees),
                ],
              ),
            ),
          ],
        ),
      );

  tabText(String text) => Container(
        height: 20,
        child: AutoSizeText(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          maxFontSize: 16,
        ),
      );
}
