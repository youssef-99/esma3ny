import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/data/models/therapist/session_history.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/session_status_mark.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientCard extends StatelessWidget {
  final SessionHistory sessionHistory;

  ClientCard({Key key, this.sessionHistory}) : super(key: key);

  final DateFormat dateFormat = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: body(context),
      ),
    );
  }

  body(context) => Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Text(
              '${dateFormat.format(DateTime.parse(sessionHistory.startTime).toLocal())}',
              style: TextStyle(color: CustomColors.blue),
            ),
          ),
          Row(
            children: [
              clientImage(),
              Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  clientName(),

                  SizedBox(height: 20),
                  customListTile(Icons.timer,
                      '${sessionHistory.duration} ${AppLocalizations.of(context).min} / ${sessionHistory.type}'),
                  // customListTile(
                  //     Icons.money, '${timeSlot.amount} / ${timeSlot.currency}'),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          bottomSection(),
        ],
      );

  clientImage() => Container(
        margin: EdgeInsets.only(right: 10),
        decoration: decoration(CustomColors.orange, 100),
        child: CachedImage(
          url: sessionHistory.profileImage.small,
          raduis: 70,
        ),
      );

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
        color: CustomColors.white,
      );

  clientName() => InkWell(
        onTap: () {},
        child: AutoSizeText(
          sessionHistory.client.name,
          maxLines: 1,
          style: TextStyle(color: CustomColors.orange, fontSize: 20),
        ),
      );

  customListTile(IconData icon, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  bottomSection() => Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: SessionStatusMark(
          sessionStatus: sessionHistory.status == FINIDHED
              ? SessionStatus.Finished
              : SessionStatus.Cancelled,
        ),
      );
}
