import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TherapistFeesList extends StatelessWidget {
  final Fees fees;
  TherapistFeesList(this.fees);

  isEgp(id) => id == 'Africa/Cairo';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<ClientTherapistProfileState>(
        builder: (context, state, child) => ListView(
          children: [
            customListTile(
              AppLocalizations.of(context).video,
              isEgp(state.client.realTimeZone)
                  ? fees.video.egp.half
                  : fees.video.usd.half,
              isEgp(state.client.realTimeZone)
                  ? fees.video.egp.full
                  : fees.video.usd.full,
              isEgp(state.client.realTimeZone),
              context,
            ),
            customListTile(
              AppLocalizations.of(context).audio,
              isEgp(state.client.realTimeZone)
                  ? fees.audio.egp.half
                  : fees.audio.usd.half,
              isEgp(state.client.realTimeZone)
                  ? fees.audio.egp.full
                  : fees.audio.usd.full,
              isEgp(state.client.realTimeZone),
              context,
            ),
            customListTile(
              AppLocalizations.of(context).chat,
              isEgp(state.client.realTimeZone)
                  ? fees.chat.egp.half
                  : fees.chat.usd.half,
              isEgp(state.client.realTimeZone)
                  ? fees.video.egp.full
                  : fees.video.usd.full,
              isEgp(state.client.realTimeZone),
              context,
            ),
          ],
        ),
      ),
    );
  }

  customListTile(
          String type, int halfPtice, int fullPrice, bool isEgp, context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('30 ${AppLocalizations.of(context).min}'),
            trailing: Text(
                '${halfPtice.toString()} ${isEgp ? AppLocalizations.of(context).egp : AppLocalizations.of(context).usd}'),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('60 ${AppLocalizations.of(context).min}'),
            trailing: Text(
                '${fullPrice.toString()} ${isEgp ? AppLocalizations.of(context).egp : AppLocalizations.of(context).usd}'),
          ),
        ],
      );
}
