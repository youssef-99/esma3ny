import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/widgets/health_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientHealthProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).health_profile,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Consumer<CallState>(
        builder: (context, state, child) =>
            HealthProfileWidget(state.clientHealthProfile),
      ),
    );
  }
}
