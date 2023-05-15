import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SlideMix';

  @override
  String get tapToStart => 'tap to start';

  @override
  String get createMovie => 'create';

  @override
  String get newMovie => 'new';

  @override
  String notEnoughMediaToCreateMovie(int minMediaCountToProceed) {
    final intl.NumberFormat minMediaCountToProceedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minMediaCountToProceedString = minMediaCountToProceedNumberFormat.format(minMediaCountToProceed);

    return 'Add $minMediaCountToProceedString or more media to create your movie';
  }

  @override
  String get leaveCreationAlertTitle => 'Leave the project?';

  @override
  String get leaveCreationAlertPrimary => 'save as draft';

  @override
  String get leaveCreationAlertSecondary => 'leave';

  @override
  String get leaveCancelAlertTitle => 'Movie is in progress, do you want to cancel?';

  @override
  String get leaveCancelAlertPrimary => 'cancel';

  @override
  String get leaveCancelAlertSecondary => 'wait';

  @override
  String get mediaSourceCamera => 'Camera';

  @override
  String get mediaSourceGallery => 'Gallery';

  @override
  String get deleteMovieAlertTitle => 'Delete the video?';

  @override
  String get deleteMovieAlertPrimary => 'delete';

  @override
  String get deleteMovieAlertSecondary => 'cancel';

  @override
  String projectTitle(int projectId) {
    final intl.NumberFormat projectIdNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String projectIdString = projectIdNumberFormat.format(projectId);

    return 'project #$projectIdString';
  }

  @override
  String draftTitle(int projectId) {
    final intl.NumberFormat projectIdNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String projectIdString = projectIdNumberFormat.format(projectId);

    return 'draft #$projectIdString';
  }

  @override
  String get failedPlayVideo => 'Failed to play your video';

  @override
  String get previewActionShare => 'Share';

  @override
  String get previewActionDelete => 'Delete';
}
