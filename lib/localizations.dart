import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as intl;
import 'package:slidemix/main.dart';

// flutter gen-l10n
class AppLocalizations {
  AppLocalizations._();

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

extension AppLocalizationsX on intl.AppLocalizations {
  String formatDuration(Duration duration) =>
      durationInSecondsSelector(duration.inMilliseconds / 1000);
}
