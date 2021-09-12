import 'package:esma3ny/data/models/client_models/therapist/therapist_profile_info.dart';
import 'package:esma3ny/data/models/enums/sessionType.dart';
import 'package:esma3ny/ui/provider/client/book_session_state.dart';
import 'package:esma3ny/ui/widgets/calender.dart';
import 'package:esma3ny/ui/widgets/sessionBookingReview.dart';
import 'package:esma3ny/ui/widgets/time_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingOptionModalSheet extends StatefulWidget {
  final Therapist therapist;
  BookingOptionModalSheet(this.therapist);
  @override
  _BookingOptionModalSheetState createState() =>
      _BookingOptionModalSheetState();
}

class _BookingOptionModalSheetState extends State<BookingOptionModalSheet> {
  BookSessionState provider;

  @override
  void initState() {
    provider = Provider.of<BookSessionState>(context, listen: false);
    provider.getToDaySessions(false);
    provider.setTherapist(widget.therapist);
    super.initState();
  }

  @override
  void dispose() {
    provider.resetValues();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookSessionState>(
      builder: (context, state, child) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 550,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      state.getToDaySessions(true);
                    },
                    child: Text(
                      AppLocalizations.of(context).today,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      state.getTomorrowSessions();
                    },
                    child: Text(
                      AppLocalizations.of(context).tomorrow,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => Calender(),
                  );
                },
                child: Text(AppLocalizations.of(context).or_choose_date),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                ),
                child: ListTile(
                  title: Text(
                    state.selectedDate,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  leading: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 310,
                child: FormBuilderRadioGroup(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  initialValue: SessionType.Video,
                  onChanged: (value) => state.setSessionType(value),
                  options: [
                    FormBuilderFieldOption(
                      value: SessionType.Video,
                      child: Text(AppLocalizations.of(context).video),
                    ),
                    FormBuilderFieldOption(
                      value: SessionType.Audio,
                      child: Text(AppLocalizations.of(context).audio),
                    ),
                    FormBuilderFieldOption(
                      value: SessionType.Chat,
                      child: Text(AppLocalizations.of(context).chat),
                    ),
                  ],
                  orientation: OptionsOrientation.horizontal,
                  name: 'session type',
                ),
              ),
              // Container(
              //   width: 200,
              //   child: FormBuilderRadioGroup(
              //     decoration: InputDecoration(
              //         border: InputBorder.none,
              //         contentPadding: EdgeInsets.symmetric(vertical: 10)),
              //     autovalidateMode: AutovalidateMode.always,
              //     onChanged: (value) {},
              //     options: [
              //       FormBuilderFieldOption(value: '30 Min'),
              //       FormBuilderFieldOption(value: '60 Min'),
              //     ],
              //     orientation: OptionsOrientation.horizontal,
              //     name: 'session type',
              //   ),
              // ),
              Text(
                AppLocalizations.of(context).choose_time,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: state.selectedTimeSlots.length == 0 ? 50 : 100,
                child: state.selectedTimeSlots.length == 0
                    ? Text(AppLocalizations.of(context).no_available_time_slot)
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.selectedTimeSlots == null
                            ? 0
                            : state.selectedTimeSlots.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => TimeTile(index),
                      ),
              ),
              Text(
                state.sessionPriceResponse != null
                    ? state.isFree
                        ? AppLocalizations.of(context).free
                        : '${state.sessionPriceResponse.price} ${state.sessionPriceResponse.currency}'
                    : '-----',
                style: TextStyle(color: Colors.green, fontSize: 20, height: 3),
              ),
              ElevatedButton(
                onPressed: () {
                  if (state.selectedTimeSlot == null)
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)
                          .choose_time_slot_to_continue,
                    );
                  else
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (_) => SessionBookingReview(
                        therapistName:
                            state.therapist.name.getLocalizedString(),
                        fees: state.sessionPriceResponse,
                        sessionType: state.sessionTypeText,
                        date: state.selectedDate,
                        timeSlot: state.selectedTimeSlot,
                      ),
                    );
                },
                child: Text(
                  AppLocalizations.of(context).continue_next,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
