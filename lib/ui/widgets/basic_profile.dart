import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';

import 'chached_image.dart';

class BasicProfile extends StatelessWidget {
  final String name, email, phone, gender, dateOfBirth, countryId, profileImage;
  final bool isEditable;
  final Widget widget;
  BasicProfile({
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.gender,
    @required this.dateOfBirth,
    @required this.countryId,
    @required this.isEditable,
    @required this.profileImage,
    this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40, bottom: 100),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CachedImage(
            url: profileImage,
            raduis: 100,
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 10),
          infoCard(context),
        ],
      ),
    );
  }

  infoCard(context) => Container(
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
            isEditable
                ? Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: EdgeInsets.only(top: 5, right: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, 'edit_therapist_bais_info');
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          fontFamily: 'arial',
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            customListTile(Icons.person, name),
            customListTile(Icons.email, email),
            customListTile(Icons.phone, phone),
            customListTile(Icons.person, gender),
            customListTile(Icons.date_range, dateOfBirth),
            FutureBuilder(
              future: SharedPrefrencesHelper.getCountryName(
                int.parse(countryId),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return customListTile(Icons.location_city, snapshot.data);
                }
                return SizedBox();
              },
            ),
            widget ?? SizedBox(),
          ],
        ),
      );

  customListTile(IconData icon, String title) =>
      ListTile(leading: Icon(icon), title: Text(title));
}
