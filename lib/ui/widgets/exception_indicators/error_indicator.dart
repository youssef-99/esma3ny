import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/generic_error_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/no_connection_indicator.dart';
import 'package:flutter/material.dart';

/// Based on the received error, displays either a [NoConnectionIndicator] or
/// a [GenericErrorIndicator].
class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    @required this.error,
    this.onTryAgain,
    Key key,
  })  : assert(error != null),
        super(key: key);

  final dynamic error;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    print(error);
    return error is NetworkConnectionException
        ? NoConnectionIndicator(
            onTryAgain: onTryAgain,
          )
        : GenericErrorIndicator(
            onTryAgain: onTryAgain,
          );
  }
}
