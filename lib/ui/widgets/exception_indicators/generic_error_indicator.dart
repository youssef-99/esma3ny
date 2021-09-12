import 'package:esma3ny/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    Key key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: AppLocalizations.of(context).something_went_wrong,
        message: AppLocalizations.of(context).the_application_encounter,
        assetName: 'assets/confused-face.png',
        onTryAgain: onTryAgain,
      );
}
