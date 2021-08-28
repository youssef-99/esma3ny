import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/widgets/health_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientHealthProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Profile',
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
