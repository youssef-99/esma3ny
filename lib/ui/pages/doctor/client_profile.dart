import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/pages/doctor/prev_client_health_profile.dart';
import 'package:esma3ny/ui/pages/doctor/previous_sessions.dart';
import 'package:esma3ny/ui/provider/public/reload_page.dart';
import 'package:esma3ny/ui/widgets/basic_profile.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientProfile extends StatelessWidget {
  final TherapistRepository _therapistRepository = TherapistRepository();
  final id;
  ClientProfile(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Client Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: body(),
          ),
        ),
      ),
    );
  }

  body() => Consumer<ReloadPageState>(
        builder: (context, state, child) => FutureBuilder<ClientModel>(
          future: _therapistRepository.getClientData(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CustomProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    BasicProfile(
                      name: snapshot.data.name,
                      email: snapshot.data.email,
                      phone: snapshot.data.phone,
                      gender: snapshot.data.gender,
                      dateOfBirth: snapshot.data.dateOfBirth,
                      countryId: snapshot.data.countryId.toString(),
                      profileImage: snapshot.data.profilImage.small,
                      isEditable: false,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PrevClientHealthProfilePage(
                                        id: id,
                                      ),
                                    ),
                                  ),
                              child: Text('Health Profile')),
                          ElevatedButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PreviousSessions(
                                        id: id,
                                      ),
                                    ),
                                  ),
                              child: Text('Sessions')),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return ErrorIndicator(
                  error: snapshot.error,
                  onTryAgain: () => state.reload(),
                );
              }
            }
            return SomethingWentWrongWidget();
          },
        ),
      );
}
