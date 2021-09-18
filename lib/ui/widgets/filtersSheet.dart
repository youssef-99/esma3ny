import 'package:chips_choice/chips_choice.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/public/specialization.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/provider/client/filters_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/colors.dart';
import '../theme/constant.dart';
import 'customDatePicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterSheet extends StatefulWidget {
  final _dateController;
  FilterSheet(this._dateController);
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DateTime selectedDate = DateTime.now();
  bool label = false;
  int genderTag = 1;
  int feesTag = 1;
  List<String> genders = ['any', 'male', 'female'];

  @override
  void initState() {
    Provider.of<FilterState>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).filters,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: CustomColors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              jobsFilterColumn(Icons.work, AppLocalizations.of(context).jobs),
              specializationFilterColumn(
                  Icons.apps, AppLocalizations.of(context).speciality),
              languageFilterColumn(
                  Icons.public, AppLocalizations.of(context).language),
              group(
                listTile(Icons.person, AppLocalizations.of(context).gender),
                genderChip(),
              ),
              Consumer<FilterState>(
                builder: (context, state, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        state.reset();
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).reset),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        state.apply();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).apply),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  specializationFilterColumn(IconData icon, String title) => Column(
        children: [
          listTile(icon, title),
          dropDownSpecializationButton(),
        ],
      );

  languageFilterColumn(IconData icon, String title) => Column(
        children: [
          listTile(icon, title),
          dropDownLanguageButton(),
        ],
      );

  jobsFilterColumn(IconData icon, String title) => Column(
        children: [
          listTile(icon, title),
          dropDownJobButton(),
        ],
      );

  group(Widget header, Widget content) => Column(
        children: [
          header,
          content,
        ],
      );

  // for titles
  listTile(IconData icon, String title) => Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(
            title,
            style: kFiltersTextTheme,
          ),
        ],
      );

  // adjust padding for the pickers
  padding(Widget child) => Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: child,
          )
        ],
      );

  dropDownSpecializationButton() => padding(
        FutureBuilder<List<Specialization>>(
            future: SharedPrefrencesHelper.getSpecializations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Specialization> list = snapshot.data;
                return DropdownButtonFormField<Specialization>(
                  hint:
                      Text(AppLocalizations.of(context).select_specialization),
                  items: <Specialization>[...list].map((Specialization value) {
                    return new DropdownMenuItem<Specialization>(
                      value: value,
                      child: new Text(value.name.getLocalizedString()),
                    );
                  }).toList(),
                  onChanged: (Specialization specialization) {
                    Provider.of<FilterState>(context, listen: false)
                        .setSpecialization(specialization);
                  },
                );
              }
              return DropdownButtonFormField(items: []);
            }),
      );

  dropDownLanguageButton() => padding(
        FutureBuilder<List<Language>>(
            future: SharedPrefrencesHelper.getLanguages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Language> list = snapshot.data;
                return DropdownButtonFormField<Language>(
                  hint: Text(AppLocalizations.of(context).select_language),
                  items: <Language>[...list].map((Language value) {
                    return new DropdownMenuItem<Language>(
                      value: value,
                      child: new Text(value.name.getLocalizedString()),
                    );
                  }).toList(),
                  onChanged: (Language language) {
                    Provider.of<FilterState>(context, listen: false)
                        .setLanguage(language);
                  },
                );
              }
              return DropdownButtonFormField(items: []);
            }),
      );

  dropDownJobButton() => padding(
        FutureBuilder<List<Job>>(
            future: SharedPrefrencesHelper.job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<Job> list = snapshot.data;
                return DropdownButtonFormField<Job>(
                  hint: Text(AppLocalizations.of(context).select_job),
                  items: <Job>[...list].map((Job value) {
                    return new DropdownMenuItem<Job>(
                      value: value,
                      child: new Text(value.name.getLocalizedString()),
                    );
                  }).toList(),
                  onChanged: (Job job) {
                    Provider.of<FilterState>(context, listen: false)
                        .setJobs(job);
                  },
                );
              }
              return DropdownButtonFormField(items: []);
            }),
      );

  datePicker() => padding(CustomDatePicker(widget._dateController));

  getLocaleGender(gender) {
    if (gender == 'male')
      return AppLocalizations.of(context).male;
    else if (gender == 'female') return AppLocalizations.of(context).female;
    return AppLocalizations.of(context).any;
  }

  genderChip() => Consumer<FilterState>(
        builder: (context, state, child) => Align(
          alignment: Alignment.center,
          child: ChipsChoice<int>.single(
            value: state.genderIndex,
            onChanged: (val) {
              genderTag = val;
              state.setGender(val);
            },
            choiceItems: C2Choice.listFrom<int, String>(
                source: genders,
                value: (i, v) => i,
                label: (i, v) => getLocaleGender(v),
                tooltip: (i, v) => v,
                style: (i, v) {
                  return C2ChoiceStyle(
                    labelStyle: TextStyle(fontSize: 18),
                  );
                }),
            choiceActiveStyle: C2ChoiceStyle(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: CustomColors.orange,
            ),
            wrapped: true,
          ),
        ),
      );
}
