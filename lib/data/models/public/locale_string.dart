import 'package:meta/meta.dart';
import 'package:esma3ny/core/.env.dart';

class LocaleString {
  final String stringEn;
  final String stringAr;

  LocaleString({
    @required this.stringEn,
    @required this.stringAr,
  });

  getLocalizedString() {
    return LANG == 'en' ? stringEn : stringAr;
  }
}
