import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'SlideMix';

  @override
  String get tapToStart => 'почати';

  @override
  String get createMovie => 'створити';

  @override
  String get newMovie => 'створити';

  @override
  String notEnoughMediaToCreateMovie(int minMediaCountToProceed) {
    final intl.NumberFormat minMediaCountToProceedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minMediaCountToProceedString = minMediaCountToProceedNumberFormat.format(minMediaCountToProceed);

    return 'Додайте $minMediaCountToProceedString чи більше файлів, щоб створити відео';
  }

  @override
  String get leaveCreationAlertTitle => 'Вийти і відмінити створення відео?';

  @override
  String get leaveCreationAlertPrimary => 'зберегти як чернетку';

  @override
  String get leaveCreationAlertSecondary => 'вийти';

  @override
  String get leaveCancelAlertTitle => 'Відео монтується, відмінити?';

  @override
  String get leaveCancelAlertPrimary => 'відмінити';

  @override
  String get leaveCancelAlertSecondary => 'зачекати';

  @override
  String get mediaSourceCamera => 'Камера';

  @override
  String get mediaSourceGallery => 'Галерея';

  @override
  String get deleteMovieAlertTitle => 'Видалити відео?';

  @override
  String get deleteMovieAlertPrimary => 'видалити';

  @override
  String get deleteMovieAlertSecondary => 'відмінити';

  @override
  String projectTitle(int projectId) {
    final intl.NumberFormat projectIdNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String projectIdString = projectIdNumberFormat.format(projectId);

    return 'проєкт #$projectIdString';
  }

  @override
  String draftTitle(int projectId) {
    final intl.NumberFormat projectIdNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String projectIdString = projectIdNumberFormat.format(projectId);

    return 'чернетка #$projectIdString';
  }

  @override
  String get failedPlayVideo => 'Не можемо відтворити ваше відео';
}