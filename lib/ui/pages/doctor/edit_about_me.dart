import 'package:chips_choice/chips_choice.dart';
import 'package:esma3ny/data/models/public/job.dart';
import 'package:esma3ny/data/models/public/language.dart';
import 'package:esma3ny/data/models/public/locale_string.dart';
import 'package:esma3ny/data/models/therapist/about_therapist.dart';
import 'package:esma3ny/ui/provider/therapist/about_me_state.dart';
import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/textFields/TextField.dart';
import 'package:esma3ny/ui/widgets/textFields/validation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAboutMePage extends StatefulWidget {
  @override
  _EditAboutMePageState createState() => _EditAboutMePageState();
}

class _EditAboutMePageState extends State<EditAboutMePage> {
  final _key = GlobalKey<FormBuilderState>();
  TextEditingController _jobEn = TextEditingController();
  TextEditingController _jobAr = TextEditingController();
  TextEditingController _bioEn = TextEditingController();
  TextEditingController _bioAr = TextEditingController();
  TherapistProfileState _therapistProfileState;
  AboutMeState _aboutMeState;
  String _selectedPrefix;
  int _selectedJobId;
  List<int> selectedLanguages = [];

  @override
  void initState() {
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    _aboutMeState = Provider.of<AboutMeState>(context, listen: false);
    _bioEn.text =
        _therapistProfileState.therapistProfileResponse.biography.stringEn;
    _bioAr.text =
        _therapistProfileState.therapistProfileResponse.biography.stringAr;
    _selectedPrefix = _therapistProfileState.therapistProfileResponse.prefix;
    _selectedJobId = _therapistProfileState.therapistProfileResponse.jobId;
    _aboutMeState.getLanguages(
        _therapistProfileState.therapistProfileResponse.languages);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).edit,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer2<TherapistProfileState, AboutMeState>(
        builder: (context, therapistState, aboutMeState, child) {
          return Container(
            padding: EdgeInsets.all(20),
            child: FormBuilder(
              key: _key,
              child: ListView(
                children: [
                  jobs(therapistState.therapistProfileResponse.jobId),
                  prefixList(therapistState.therapistProfileResponse.prefix),
                  bioEn(therapistState
                      .therapistProfileResponse.biography.stringEn),
                  bioAr(therapistState
                      .therapistProfileResponse.biography.stringAr),
                  languages(),
                  SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState.validate()) {
                          await aboutMeState.edit(aboutMeModel());
                          await therapistState.updateProfile();
                          if (aboutMeState.isUpdated) Navigator.pop(context);
                        }
                      },
                      child: aboutMeState.loading
                          ? CustomProgressIndicator()
                          : Text(AppLocalizations.of(context).edit)),
                ],
              ),
            ),
          );
        },
      );

  jobEn(String title) => ValidationError(
        textField: TextFieldForm(
          hint: AppLocalizations.of(context).job_title_in_english,
          prefixIcon: Icons.work,
          validate: FormBuilderValidators.required(context),
          controller: _jobEn,
        ),
        error: _aboutMeState.errors['title_en'],
      );

  jobAr(String title) => ValidationError(
        textField: TextFieldForm(
          hint: AppLocalizations.of(context).job_title_in_arabic,
          prefixIcon: Icons.work,
          validate: FormBuilderValidators.required(context),
          controller: _jobAr,
        ),
        error: _aboutMeState.errors['title_ar'],
      );

  prefixList(String prefix) => Consumer<AboutMeState>(
        builder: (context, state, child) => ValidationError(
          textField: FormBuilderDropdown(
            name: 'Prefix',
            hint: Text('Prefix'),
            initialValue: prefix,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: CustomColors.blue,
              ),
              labelText: AppLocalizations.of(context).prefix,
            ),
            items: state.prefixes
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (v) {
              _selectedPrefix = v;
            },
            validator: FormBuilderValidators.required(context),
          ),
          error: state.errors['prefix'],
        ),
      );

  jobs(int jobId) {
    return _aboutMeState.jobs.isEmpty
        ? FutureBuilder(
            future: _aboutMeState.getJobs(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.done
                    ? jobField(jobId)
                    : SizedBox(),
          )
        : jobField(jobId);
  }

  jobField(int jobId) => ValidationError(
        textField: FormBuilderDropdown<Job>(
          name: 'job name',
          initialValue: _aboutMeState.jobs[jobId - 1],
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.work_outline_rounded,
              color: CustomColors.blue,
            ),
            labelText: AppLocalizations.of(context).job_name,
          ),
          items: _aboutMeState.jobs
              .map(
                (Job job) => DropdownMenuItem<Job>(
                  child: Text(job.name.getLocalizedString()),
                  value: job,
                ),
              )
              .toList(),
          onChanged: (Job job) {
            _selectedJobId = job.id;
          },
          validator: FormBuilderValidators.required(context),
        ),
        error: _aboutMeState.errors['job_id'],
      );

  bioEn(String bio) => ValidationError(
        textField: TextFieldForm(
          hint: AppLocalizations.of(context).bio_in_english,
          prefixIcon: Icons.menu_book_sharp,
          validate: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(context, 100),
            FormBuilderValidators.required(context),
          ]),
          controller: _bioEn,
          maxLines: 3,
          autoValidateMode: AutovalidateMode.always,
        ),
        error: _aboutMeState.errors['biography_en'],
      );

  bioAr(String bio) => ValidationError(
        textField: TextFieldForm(
          hint: AppLocalizations.of(context).bio_in_arabic,
          prefixIcon: Icons.menu_book_sharp,
          controller: _bioAr,
          maxLines: 3,
          validate: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(context, 100),
            FormBuilderValidators.required(context),
          ]),
          autoValidateMode: AutovalidateMode.always,
        ),
        error: _aboutMeState.errors['biography_ar'],
      );

  languages() => Consumer<AboutMeState>(
        builder: (context, state, child) => ChipsChoice<int>.multiple(
          value: state.selectedLanguage,
          onChanged: (val) {
            state.setLanguages(val);
          },
          choiceItems: C2Choice.listFrom<int, Language>(
            source: state.languages,
            value: (i, v) => i + 1,
            label: (i, v) => v.name.getLocalizedString(),
            tooltip: (i, v) => v.id.toString(),
            style: (i, v) {
              return C2ChoiceStyle(
                labelStyle: TextStyle(fontSize: 18),
              );
            },
          ),
          choiceActiveStyle: C2ChoiceStyle(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: CustomColors.orange,
          ),
          wrapped: true,
        ),
      );

  AboutTherapistModel aboutMeModel() {
    return AboutTherapistModel(
      title: LocaleString(
        stringEn: _jobEn.text,
        stringAr: _jobAr.text,
      ),
      prefix: _selectedPrefix,
      biography: LocaleString(
        stringEn: _bioEn.text,
        stringAr: _bioAr.text,
      ),
      jobId: _selectedJobId,
      languageId: _aboutMeState.selectedLanguage,
    );
  }
}
