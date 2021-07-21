import 'package:esma3ny/ui/widgets/exception_indicators/exception_indicator.dart';
import 'package:flutter/cupertino.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const ExceptionIndicator(
        title: 'No results found!',
        message: 'We couldn\'t find any results matching your applied filters.',
        assetName: 'assets/empty-box.png',
      );
}
