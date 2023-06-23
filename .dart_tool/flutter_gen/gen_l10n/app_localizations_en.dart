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
  String get createMovieProgress => 'Making the magic, please wait a bit...';

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
  String get pickMediaDialogTitle => 'Choose images from';

  @override
  String get mediaSourceCamera => 'Camera';

  @override
  String get mediaSourceGallery => 'Gallery';

  @override
  String get changeCreationSettingsDialogTitle => 'Apply effects';

  @override
  String durationInSecondsSelector(double seconds) {
    return '$seconds s';
  }

  @override
  String slideDurationSelector(String duration) {
    return 'Slide duration: $duration';
  }

  @override
  String changeCreationSettingsTransition(String transition) {
    return 'Transition: $transition';
  }

  @override
  String transitionDurationSelector(String duration) {
    return 'Transition duration: $duration';
  }

  @override
  String changeCreationSettingsOrientation(String orientation) {
    return 'Orientation: $orientation';
  }

  @override
  String get pickTransitionDialogTitle => 'Choose transition';

  @override
  String get transitionNone => 'No transition';

  @override
  String get pickOrientationDialogTitle => 'Choose orientation';

  @override
  String orientationSelector(String orientation) {
    String _temp0 = intl.Intl.selectLogic(
      orientation,
      {
        'landscape': 'Landscape',
        'portrait': 'Portrait',
        'square': 'Square',
        'other': '',
      },
    );
    return '$_temp0';
  }

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
