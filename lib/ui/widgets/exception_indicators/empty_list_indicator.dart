import 'package:esma3ny/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: AppLocalizations.of(context).no_result_found,
        message: AppLocalizations.of(context).we_couldnt_find_result,
        assetName: 'assets/empty-box.png',
      );
}
