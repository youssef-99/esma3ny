import 'package:esma3ny/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Indicates that a connection error occurred.
class NoConnectionIndicator extends StatelessWidget {
  const NoConnectionIndicator({
    Key key,
    this.onTryAgain,
  }) : super(key: key);

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: AppLocalizations.of(context).no_connection,
        message: AppLocalizations.of(context).please_check_internert,
        assetName: 'assets/frustrated-face.png',
        onTryAgain: onTryAgain,
      );
}
