import 'package:dio/dio.dart';
import 'package:esma3ny/core/network/ApiBaseHelper.dart';
import 'package:esma3ny/data/models/public/profileImage.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareNotesPage extends StatefulWidget {
  final String uid;

  const ShareNotesPage({Key key, @required this.uid}) : super(key: key);
  @override
  _ShareNotesPageState createState() => _ShareNotesPageState();
}

class _ShareNotesPageState extends State<ShareNotesPage> {
  TextEditingController search = TextEditingController();
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<DoctorSearchModel> therapists = [];

  onSearch() async {
    if (search.text.isNotEmpty) {
      loading = true;
      setState(() {});
      Response response = await _apiBaseHelper.getHTTP(
          'doctor/rooms/${widget.uid}/find-therapist?name=${search.text}');
      print(response.data);
      response.data.forEach((therapist) {
        therapists.add(DoctorSearchModel.fromJson(therapist));
      });
      loading = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).search_for_therapist,
      );
    }
  }

  applyTherapist(id) async {
    loading = true;
    setState(() {});

    try {
      await _apiBaseHelper.postHTTP(
          'doctor/rooms/${widget.uid}/apply-therapist', {'doctor_id': id});

      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).notes_shared_successfully,
          backgroundColor: Colors.green);
    } catch (e) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)
              .client_didnt_authorized_notes_referral,
          backgroundColor: Colors.red);
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: search,
            decoration:
                InputDecoration(hintText: AppLocalizations.of(context).search),
            onSubmitted: (value) => onSearch(),
          ),
          actions: [
            IconButton(
              onPressed: () => onSearch(),
              icon: Icon(
                Icons.search,
                color: CustomColors.orange,
              ),
            ),
          ],
        ),
        body: loading
            ? CustomProgressIndicator()
            : ListView.builder(
                itemCount: therapists.length,
                itemBuilder: (context, idx) => ListTile(
                  onTap: () => applyTherapist(therapists[idx].id),
                  leading: CachedImage(
                    raduis: 20,
                    url: therapists[idx].profileImage.small,
                  ),
                  title: Text(therapists[idx].nameEn),
                ),
              ));
  }
}

class DoctorSearchModel {
  final int id;
  final String nameEn;
  final ProfileImage profileImage;

  DoctorSearchModel(this.id, this.nameEn, this.profileImage);

  factory DoctorSearchModel.fromJson(Map<String, dynamic> json) {
    return DoctorSearchModel(
      json['id'],
      json['name_en'],
      ProfileImage.fromjson(json['profile_image']),
    );
  }
}
