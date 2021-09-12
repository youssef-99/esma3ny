import 'package:esma3ny/ui/provider/therapist/profile_state.dart';
import 'package:esma3ny/ui/widgets/basic_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BasicInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).basic_info,
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

  body() => Consumer<TherapistProfileState>(
        builder: (context, state, child) => BasicProfile(
          name: state.therapistProfileResponse.name.getLocalizedString(),
          email: state.therapistProfileResponse.email,
          phone: state.therapistProfileResponse.phone,
          gender: state.therapistProfileResponse.gender,
          dateOfBirth: state.therapistProfileResponse.dateOfBirth,
          countryId: state.therapistProfileResponse.countryId,
          profileImage: state.therapistProfileResponse.profileImage.small,
          isEditable: true,
        ),
      );
}
