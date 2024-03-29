import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../provider/public/roleState.dart';
import '../../theme/colors.dart';
import '../../widgets/SignupForm.dart';
import '../../widgets/role/pickedRole.dart';
import '../../widgets/role/unpickedRole.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.blue,
        title: Text('Sign Up'),
      ),
      body: Container(
        child: columnBody(),
      ),
    );
  }

  columnBody() => Column(
        children: [
          roles(),
          SignupForm(),
        ],
      );

  roles() => Consumer<RoleState>(
        builder: (context, role, child) {
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    role.clientPressed();
                  },
                  child: role.client
                      ? PickedRole(RoleEnum.Client)
                      : UnpickedRole(RoleEnum.Client),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => role.therapistPressed(),
                  child: role.therapist
                      ? PickedRole(RoleEnum.Therapist)
                      : UnpickedRole(RoleEnum.Therapist),
                ),
              ),
            ],
          );
        },
      );
}
