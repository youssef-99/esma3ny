import 'package:esma3ny/data/models/public/job.dart';
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

  @override
  void initState() {
    _therapistProfileState =
        Provider.of<TherapistProfileState>(context, listen: false);
    _aboutMeState = Provider.of<AboutMeState>(context, listen: false);
    _jobEn.text =
        _therapistProfileState.therapistProfileResponse.title.stringEn;
    _jobAr.text =
        _therapistProfileState.therapistProfileResponse.title.stringAr;
    _bioEn.text =
        _therapistProfileState.therapistProfileResponse.biography.stringEn;
    _bioAr.text =
        _therapistProfileState.therapistProfileResponse.biography.stringAr;
    _selectedPrefix = _therapistProfileState.therapistProfileResponse.prefix;
    _selectedJobId = _therapistProfileState.therapistProfileResponse.jobId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit About Me',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer2<TherapistProfileState, AboutMeState>(
        builder: (context, therapistState, aboutMeState, child) => Container(
          padding: EdgeInsets.all(20),
          child: FormBuilder(
            key: _key,
            child: ListView(
              children: [
                jobs(therapistState.therapistProfileResponse.jobId),
                jobEn(therapistState.therapistProfileResponse.title.stringEn),
                jobAr(therapistState.therapistProfileResponse.title.stringAr),
                prefixList(therapistState.therapistProfileResponse.prefix),
                bioEn(
                    therapistState.therapistProfileResponse.biography.stringEn),
                bioAr(
                    therapistState.therapistProfileResponse.biography.stringAr),
                SizedBox(height: 50),
                aboutMeState.loading
                    ? CustomProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            await aboutMeState.edit(aboutMeModel());
                            await therapistState.updateProfile();
                            if (aboutMeState.isUpdated) Navigator.pop(context);
                          }
                        },
                        child: Text('Edit')),
              ],
            ),
          ),
        ),
      );

  jobEn(String title) => ValidationError(
        textField: TextFieldForm(
          hint: 'Job Title in English',
          prefixIcon: Icons.work,
          validate: FormBuilderValidators.required(context),
          controller: _jobEn,
        ),
        error: _aboutMeState.errors['title_en'],
      );

  jobAr(String title) => ValidationError(
        textField: TextFieldForm(
          hint: 'Job Title in Arabic',
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
                labelText: 'Prefix'),
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

  jobs(int jobId) => FutureBuilder<List<Job>>(
        future: _aboutMeState.getJobs(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? ValidationError(
                    textField: FormBuilderDropdown(
                      name: 'job name',
                      initialValue: snapshot.data[jobId - 1],
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.work_outline_rounded,
                            color: CustomColors.blue,
                          ),
                          labelText: 'Job Name'),
                      items: snapshot.data
                          .map(
                            (Job e) => DropdownMenuItem(
                              child: Text(e.name.getLocalizedString()),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (Job job) {
                        _selectedJobId = job.id;
                      },
                      validator: FormBuilderValidators.required(context),
                    ),
                    error: _aboutMeState.errors['job_id'],
                  )
                : SizedBox(),
      );

  bioEn(String bio) => ValidationError(
        textField: TextFieldForm(
          hint: 'Bio in English',
          prefixIcon: Icons.menu_book_sharp,
          validate: FormBuilderValidators.required(context),
          controller: _bioEn,
          maxLines: 3,
        ),
        error: _aboutMeState.errors['biography_en'],
      );

  bioAr(String bio) => ValidationError(
        textField: TextFieldForm(
          hint: 'Bio in Arabic',
          prefixIcon: Icons.menu_book_sharp,
          validate: FormBuilderValidators.required(context),
          controller: _bioAr,
          maxLines: 3,
        ),
        error: _aboutMeState.errors['biography_ar'],
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
      languageId: [1, 2],
    );
  }
}
