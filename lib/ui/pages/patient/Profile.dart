import 'package:esma3ny/data/models/client_models/Client.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/edit_profile_state.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:esma3ny/ui/widgets/waiting_wiget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text('Profile',
            style: Theme.of(context).appBarTheme.titleTextStyle),
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
              return WaitingWidget();
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
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(client.profilImage == null
                  ? 'https://esma3ny.org/assets/images/team/team-33.jpg'
                  : client.profilImage),
            ),
            Text(
              client.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            infoCard(client),
          ],
        ),
      );

  infoCard(ClientModel client) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 5, right: 10),
              child: TextButton(
                onPressed: () {
                  Provider.of<EditProfileState>(context, listen: false)
                      .initClient(client);
                  Navigator.pushNamed(context, 'edit_profile');
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 20, decoration: TextDecoration.underline),
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
                  if (snapshot.connectionState == ConnectionState.done)
                    return customListTile(Icons.location_city, snapshot.data);
                  return SizedBox();
                }),
            customListTile(Icons.timer, client.age),
          ],
        ),
      );

  customListTile(IconData icon, String title) =>
      ListTile(leading: Icon(icon), title: Text(title));
}
