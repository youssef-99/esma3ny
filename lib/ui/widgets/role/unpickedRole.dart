import 'package:flutter/material.dart';

import '../../../data/models/enums/RoleEnum.dart';
import '../../theme/colors.dart';
import 'role.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnpickedRole extends StatelessWidget {
  final RoleEnum roleType;
  final Color circleColor;
  final Color avatarColor;
  UnpickedRole(this.roleType, this.circleColor, this.avatarColor);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: CustomColors.white,
      avatarColor: avatarColor,
      circleAvatarColor: circleColor,
      roleType: roleType == RoleEnum.Client
          ? AppLocalizations.of(context).client
          : AppLocalizations.of(context).therapist,
      textColor:
          roleType == RoleEnum.Client ? CustomColors.orange : CustomColors.blue,
    );
  }
}
