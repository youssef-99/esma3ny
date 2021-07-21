import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:flutter/material.dart';

class TherapistFeesList extends StatelessWidget {
  final Fees fees;
  TherapistFeesList(this.fees);

  isEgp(id) => id == '62';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
        future: SharedPrefrencesHelper.getLoginData().then(
          (LoginResponse value) => value.country.id,
        ),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? ListView(
                    children: [
                      customListTile(
                        'Video',
                        isEgp(snapshot.data)
                            ? fees.video.egp.half
                            : fees.video.usd.half,
                        isEgp(snapshot.data)
                            ? fees.video.egp.full
                            : fees.video.usd.full,
                        isEgp(snapshot.data),
                      ),
                      customListTile(
                        'Audio',
                        isEgp(snapshot.data)
                            ? fees.audio.egp.half
                            : fees.audio.usd.half,
                        isEgp(snapshot.data)
                            ? fees.audio.egp.full
                            : fees.audio.usd.full,
                        isEgp(snapshot.data),
                      ),
                      customListTile(
                        'Chat',
                        isEgp(snapshot.data)
                            ? fees.chat.egp.half
                            : fees.chat.usd.half,
                        isEgp(snapshot.data)
                            ? fees.video.egp.full
                            : fees.video.usd.full,
                        isEgp(snapshot.data),
                      ),
                    ],
                  )
                : SizedBox(),
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
