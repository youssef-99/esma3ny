import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/booking_option.dart';
import 'package:esma3ny/ui/widgets/calender.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class TherapistInfoCard extends StatefulWidget {
  final Therapist therapist;
  TherapistInfoCard(this.therapist);
  @override
  _TherapistInfoCardState createState() => _TherapistInfoCardState();
}

class _TherapistInfoCardState extends State<TherapistInfoCard> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                therapistImage(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    therapistName(),
                    Text(
                      widget.therapist.titleEn,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    lanchUrl('tel:${widget.therapist.phone}', Icons.phone,
                        widget.therapist.phone),
                    lanchUrl('mailto:${widget.therapist.email}', Icons.email,
                        widget.therapist.email),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            bottomSection(),
          ],
        ),
      );

  lanchUrl(String launchText, icon, text) => InkWell(
        onTap: () => launch(launchText),
        child: customListTile(icon, text),
      );

  therapistImage() => Container(
        margin: EdgeInsets.only(right: 10),
        decoration: decoration(CustomColors.orange, 100),
        child: CircleAvatar(
          radius: 60,
          // backgroundImage: NetworkImage(widget.therapist.profileImage),
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

  therapistName() => AutoSizeText(
        widget.therapist.nameEn,
        maxLines: 1,
        style: TextStyle(color: CustomColors.orange, fontSize: 20),
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

  bottomSection() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(() {}, 'Start your free session', CustomColors.orange),
          button(
            () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => BookingOptionModalSheet(),
              );
            },
            'Book',
            CustomColors.blue,
          ),
        ],
      );
  button(onPressed, String text, Color color) => ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
        ),
      );
}
