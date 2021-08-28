import 'package:esma3ny/data/models/therapist/client_health_profile.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/provider/public/reload_page.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/health_profile.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrevClientHealthProfilePage extends StatelessWidget {
  final TherapistRepository _therapistRepository = TherapistRepository();
  final id;

  PrevClientHealthProfilePage({Key key, @required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<ReloadPageState>(
        builder: (context, state, child) => FutureBuilder<ClientHealthProfile>(
          future: _therapistRepository.getClientHealthProfile(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CustomProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return HealthProfileWidget(snapshot.data);
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
