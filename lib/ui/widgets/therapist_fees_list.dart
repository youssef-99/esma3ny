import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/ui/provider/client/edit_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TherapistFeesList extends StatelessWidget {
  final Fees fees;
  TherapistFeesList(this.fees);

  isEgp(context) =>
      Provider.of<EditProfileState>(context).client.countryId == '62';

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileState>(
      builder: (context, state, child) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            customListTile(
              'Video',
              isEgp(context) ? fees.video.egp.half : fees.video.usd.half,
              isEgp(context) ? fees.video.egp.full : fees.video.usd.full,
              isEgp(context),
            ),
            customListTile(
              'Audio',
              isEgp(context) ? fees.audio.egp.half : fees.audio.usd.half,
              isEgp(context) ? fees.audio.egp.full : fees.audio.usd.full,
              isEgp(context),
            ),
            customListTile(
              'Chat',
              isEgp(context) ? fees.chat.egp.half : fees.chat.usd.half,
              isEgp(context) ? fees.video.egp.full : fees.video.usd.full,
              isEgp(context),
            ),
          ],
        ),
      ),
    );
  }

  customListTile(String type, int halfPtice, int fullPrice, bool isEgp) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('30 Min'),
            trailing: Text('${halfPtice.toString()} ${isEgp ? 'EGP' : 'USD'}'),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('60 Min'),
            trailing: Text('${fullPrice.toString()} ${isEgp ? 'EGP' : 'USD'}'),
          ),
        ],
      );
}
