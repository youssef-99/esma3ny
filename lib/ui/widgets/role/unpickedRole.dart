import 'package:flutter/material.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../theme/colors.dart';
import 'role.dart';

class UnpickedRole extends StatelessWidget {
  final RoleEnum roleType;
  UnpickedRole(this.roleType);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: CustomColors.white,
      avatarColor: CustomColors.blue,
      circleAvatarColor: CustomColors.lightBlue,
      roleType: roleType,
    );
  }
}
