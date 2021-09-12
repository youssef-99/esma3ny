import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).fees,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, 'edit_session_fees'),
              child: Text('Edit'))
        ],
      ),
      body: Consumer<TherapistProfileState>(
        builder: (context, state, child) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              customListTile(
                AppLocalizations.of(context).video,
                state.therapistProfileResponse.fees.video.usd,
                state.therapistProfileResponse.fees.video.egp,
                context,
              ),
              customListTile(
                AppLocalizations.of(context).audio,
                state.therapistProfileResponse.fees.audio.usd,
                state.therapistProfileResponse.fees.audio.egp,
                context,
              ),
              customListTile(
                AppLocalizations.of(context).chat,
                state.therapistProfileResponse.fees.chat.usd,
                state.therapistProfileResponse.fees.video.egp,
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  customListTile(String type, FeesAmount feesAmountUSD,
          FeesAmount feesAmountEGP, context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text(AppLocalizations.of(context).price_for_60_min),
            trailing: Column(
              children: [
                Text(
                  '${feesAmountUSD.full.toString()} ${AppLocalizations.of(context).usd}',
                ),
                Text(
                  '${feesAmountEGP.full.toString()} ${AppLocalizations.of(context).egp}',
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('60 Min'),
            trailing: Column(
              children: [
                Text(
                    '${feesAmountUSD.half.toString()} ${AppLocalizations.of(context).usd}'),
                Text(
                    '${feesAmountEGP.half.toString()} ${AppLocalizations.of(context).egp}')
              ],
            ),
          ),
        ],
      );
}
