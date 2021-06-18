import 'package:esma3ny/data/models/public/fees.dart';
import 'package:flutter/material.dart';

class FeesPage extends StatelessWidget {
  final Fees fees;

  const FeesPage({Key key, @required this.fees}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fees',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [TextButton(onPressed: () {}, child: Text('Edit'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            customListTile(
              'Video',
              fees.video.usd,
              fees.video.egp,
            ),
            customListTile(
              'Audio',
              fees.audio.usd,
              fees.audio.egp,
            ),
            customListTile('Chat', fees.chat.usd, fees.video.egp),
          ],
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
