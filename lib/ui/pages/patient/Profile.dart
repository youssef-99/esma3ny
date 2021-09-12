import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/client/edit_profile_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();
  Future<dynamic> get _getClientInfo => _clientRepositoryImpl.getProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).profile,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: body(),
          ),
        ),
      ),
    );
  }

  body() => Consumer<EditProfileState>(
        builder: (context, state, child) => FutureBuilder(
          future: _getClientInfo,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting)
              return CustomProgressIndicator();
            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasData) {
                state.initClient(snapShot.data);
                return dataWidget(snapShot.data);
              } else if (snapShot.hasError) {
                return errorHandling(snapShot.error);
              }
            }
            return SomethingWentWrongWidget();
          },
        ),
      );

  errorHandling(dynamic error) {
    return ErrorIndicator(
      error: error,
      onTryAgain: () => setState(() {}),
    );
  }

  dataWidget(ClientModel client) => Container(
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 100),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CachedImage(
              url: client.profilImage.small,
              raduis: 100,
            ),
            SizedBox(height: 10),
            Text(
              client.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 10),
            infoCard(client),
          ],
        ),
      );

  infoCard(ClientModel client) => Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.blue,
            width: 3,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.bottomEnd,
              padding: EdgeInsets.only(top: 5, right: 10),
              child: TextButton(
                onPressed: () {
                  Provider.of<EditProfileState>(context, listen: false)
                      .initClient(client);
                  Navigator.pushNamed(context, 'edit_profile');
                },
                child: Text(
                  AppLocalizations.of(context).edit,
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      fontFamily: 'arial'),
                ),
              ),
            ),
            customListTile(Icons.person, client.name),
            customListTile(Icons.email, client.email),
            customListTile(Icons.phone, client.phone),
            customListTile(Icons.person, client.gender),
            customListTile(Icons.date_range, client.dateOfBirth),
            FutureBuilder(
                future: SharedPrefrencesHelper.getCountryName(client.countryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                    return customListTile(Icons.location_city, snapshot.data);
                  }
                  return SizedBox();
                }),
            customListTile(Icons.timer, client.age),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, 'health_profile');
                //   },
                //   child: Text('Health Profile'),
                // ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'session_history');
                  },
                  child: Text(AppLocalizations.of(context).session_list),
                ),
              ],
            )
          ],
        ),
      );

  customListTile(IconData icon, String title) =>
      ListTile(leading: Icon(icon), title: Text(title));
}
