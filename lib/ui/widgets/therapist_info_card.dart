import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/data/models/public/available_time_slot_response.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/provider/client/therapist_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/booking_option.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TherapistInfoCard extends StatefulWidget {
  final Therapist therapist;
  TherapistInfoCard(this.therapist);
  @override
  _TherapistInfoCardState createState() => _TherapistInfoCardState();
}

class _TherapistInfoCardState extends State<TherapistInfoCard> {
  PublicRepository _publicRepository = PublicRepository();
  DateFormat format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      widget.therapist.job.name.getLocalizedString(),
                      style: TextStyle(
                        // color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    lanchUrl(
                      'tel:${widget.therapist.phone}',
                      Icons.phone,
                      widget.therapist.phone,
                    ),
                    lanchUrl(
                      'mailto:${widget.therapist.email}',
                      Icons.email,
                      widget.therapist.email,
                    ),
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
        decoration: decoration(CustomColors.orange, 100),
        child: CachedImage(
          url: widget.therapist.profileImage.small,
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

  therapistName() => AutoSizeText(
        widget.therapist.name.getLocalizedString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(color: CustomColors.orange, fontSize: 20),
      );

  customListTile(IconData icon, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CustomColors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );

  bottomSection() => Consumer<ClientTherapistProfileState>(
        builder: (context, state, child) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              state.client.hasSessionFree == '1'
                  ? button(() async {
                      List<AvailableTimeSlotResponse> list;
                      await ExceptionHandling.hanleToastException(() async {
                        list = await _publicRepository.showTherapistTimeSlots(
                            widget.therapist.id,
                            format.format(DateTime.now()).toString());
                      }, '', false);

                      Provider.of<BookSessionState>(context, listen: false)
                          .setAvailableTimeSlots(list, free: true);

                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            BookingOptionModalSheet(widget.therapist),
                      );
                    }, 'Start your free session', CustomColors.orange)
                  : SizedBox(),
              SizedBox(width: 10),
              button(
                () async {
                  List<AvailableTimeSlotResponse> list;
                  await ExceptionHandling.hanleToastException(() async {
                    list = await _publicRepository.showTherapistTimeSlots(
                        widget.therapist.id,
                        format.format(DateTime.now()).toString());
                  }, '', false);

                  Provider.of<BookSessionState>(context, listen: false)
                      .setAvailableTimeSlots(list, free: false);

                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        BookingOptionModalSheet(widget.therapist),
                  );
                },
                'Book',
                CustomColors.blue,
              ),
            ],
          ),
        ),
      );
  button(onPressed, String text, Color color) => ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
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
