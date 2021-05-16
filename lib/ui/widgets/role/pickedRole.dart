import 'package:flutter/material.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../theme/colors.dart';
import 'role.dart';

class PickedRole extends StatelessWidget {
  final RoleEnum roleType;
  PickedRole(this.roleType);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: CustomColors.lightBlue,
      avatarColor: CustomColors.white,
      circleAvatarColor: CustomColors.blue,
      roleType: roleType,
    );
  }
}
