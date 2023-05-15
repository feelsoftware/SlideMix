import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as intl;
import 'package:slidemix/main.dart';

class AppLocalizations {
  static intl.AppLocalizations of(BuildContext context) =>
      intl.AppLocalizations.of(context)!;

  static intl.AppLocalizations? app() {
    final context = SlideMixApp.navigatorKey.currentContext;
    if (context == null) {
      return null;
    }
    return of(context);
  }

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      intl.AppLocalizations.localizationsDelegates;

  static List<Locale> get supportedLocales => intl.AppLocalizations.supportedLocales;
}
