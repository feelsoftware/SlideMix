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
  String get pickMediaDialogTitle => 'Виберіть зображення з';

  @override
  String get mediaSourceCamera => 'Камери';

  @override
  String get mediaSourceGallery => 'Галереї';

  @override
  String get changeCreationSettingsDialogTitle => 'Застосуйте ефекти';

  @override
  String changeCreationSettingsTransition(String transition) {
    return 'Перехід: $transition';
  }

  @override
  String changeCreationSettingsOrientation(String orientation) {
    return 'Орієнтація: $orientation';
  }

  @override
  String get pickTransitionDialogTitle => 'Виберіть перехід';

  @override
  String get transitionNone => 'Без переходів';

  @override
  String get pickOrientationDialogTitle => 'Виберіть орієнтацію';

  @override
  String orientationSelector(String orientation) {
    String _temp0 = intl.Intl.selectLogic(
      orientation,
      {
        'landscape': 'Пейзажна',
        'portrait': 'Портретна',
        'square': 'Квадратна',
        'other': '',
      },
    );
    return '$_temp0';
  }

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

  @override
  String get previewActionShare => 'Поділитися';

  @override
  String get previewActionDelete => 'Видалити';
}
