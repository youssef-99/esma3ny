import 'package:flutter/material.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../theme/colors.dart';
import 'role.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickedRole extends StatelessWidget {
  final RoleEnum roleType;
  PickedRole(this.roleType);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: CustomColors.lightBlue,
      avatarColor: CustomColors.white,
      circleAvatarColor: CustomColors.blue,
      roleType: roleType == RoleEnum.Client
          ? AppLocalizations.of(context).client
          : AppLocalizations.of(context).therapist,
    );
  }
}
