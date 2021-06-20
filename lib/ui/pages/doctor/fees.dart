import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fees',
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
                'Video',
                state.therapistProfileResponse.fees.video.usd,
                state.therapistProfileResponse.fees.video.egp,
              ),
              customListTile(
                'Audio',
                state.therapistProfileResponse.fees.audio.usd,
                state.therapistProfileResponse.fees.audio.egp,
              ),
              customListTile(
                'Chat',
                state.therapistProfileResponse.fees.chat.usd,
                state.therapistProfileResponse.fees.video.egp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  customListTile(
          String type, FeesAmount feesAmountUSD, FeesAmount feesAmountEGP) =>
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
            trailing: Column(
              children: [
                Text('${feesAmountUSD.full.toString()} USD'),
                Text('${feesAmountEGP.full.toString()} EGP')
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_1_outlined),
            title: Text('60 Min'),
            trailing: Column(
              children: [
                Text('${feesAmountUSD.half.toString()} USD'),
                Text('${feesAmountEGP.half.toString()} EGP')
              ],
            ),
          ),
        ],
      );
}
