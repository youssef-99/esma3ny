import 'package:flutter/material.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../theme/colors.dart';
import 'role.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnpickedRole extends StatelessWidget {
  final RoleEnum roleType;
  UnpickedRole(this.roleType);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: CustomColors.white,
      avatarColor: CustomColors.blue,
      circleAvatarColor: CustomColors.lightBlue,
      roleType: roleType == RoleEnum.Client
          ? AppLocalizations.of(context).client
          : AppLocalizations.of(context).therapist,
    );
  }
}
