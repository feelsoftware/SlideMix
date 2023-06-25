import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SlideMix'**
  String get appName;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'tap to start'**
  String get tapToStart;

  /// No description provided for @createMovie.
  ///
  /// In en, this message translates to:
  /// **'create'**
  String get createMovie;

  /// No description provided for @newMovie.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get newMovie;

  /// No description provided for @createMovieProgress.
  ///
  /// In en, this message translates to:
  /// **'Making the magic, please wait a bit...'**
  String get createMovieProgress;

  /// No description provided for @notEnoughMediaToCreateMovie.
  ///
  /// In en, this message translates to:
  /// **'Add {minMediaCountToProceed} or more media to create your movie'**
  String notEnoughMediaToCreateMovie(int minMediaCountToProceed);

  /// No description provided for @leaveCreationAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the project?'**
  String get leaveCreationAlertTitle;

  /// No description provided for @leaveCreationAlertPrimary.
  ///
  /// In en, this message translates to:
  /// **'save as draft'**
  String get leaveCreationAlertPrimary;

  /// No description provided for @leaveCreationAlertSecondary.
  ///
  /// In en, this message translates to:
  /// **'leave'**
  String get leaveCreationAlertSecondary;

  /// No description provided for @leaveCancelAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie is in progress, do you want to cancel?'**
  String get leaveCancelAlertTitle;

  /// No description provided for @leaveCancelAlertPrimary.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get leaveCancelAlertPrimary;

  /// No description provided for @leaveCancelAlertSecondary.
  ///
  /// In en, this message translates to:
  /// **'wait'**
  String get leaveCancelAlertSecondary;

  /// No description provided for @pickMediaDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose images from'**
  String get pickMediaDialogTitle;

  /// No description provided for @mediaSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get mediaSourceCamera;

  /// No description provided for @mediaSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get mediaSourceGallery;

  /// No description provided for @changeCreationSettingsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply effects'**
  String get changeCreationSettingsDialogTitle;

  /// No description provided for @durationInSecondsSelector.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationInSecondsSelector(double seconds);

  /// No description provided for @slideDurationSelector.
  ///
  /// In en, this message translates to:
  /// **'Slide duration: {duration}'**
  String slideDurationSelector(String duration);

  /// No description provided for @changeCreationSettingsTransition.
  ///
  /// In en, this message translates to:
  /// **'Transition: {transition}'**
  String changeCreationSettingsTransition(String transition);

  /// No description provided for @transitionDurationSelector.
  ///
  /// In en, this message translates to:
  /// **'Transition duration: {duration}'**
  String transitionDurationSelector(String duration);

  /// No description provided for @changeCreationSettingsOrientation.
  ///
  /// In en, this message translates to:
  /// **'Orientation: {orientation}'**
  String changeCreationSettingsOrientation(String orientation);

  /// No description provided for @changeCreationSettingsResize.
  ///
  /// In en, this message translates to:
  /// **'Scale rules: {resize}'**
  String changeCreationSettingsResize(String resize);

  /// No description provided for @pickTransitionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose transition'**
  String get pickTransitionDialogTitle;

  /// No description provided for @transitionNone.
  ///
  /// In en, this message translates to:
  /// **'No transition'**
  String get transitionNone;

  /// No description provided for @pickOrientationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose orientation'**
  String get pickOrientationDialogTitle;

  /// No description provided for @orientationSelector.
  ///
  /// In en, this message translates to:
  /// **'{orientation,select, landscape{Landscape}portrait{Portrait}square{Square}other{}}'**
  String orientationSelector(String orientation);

  /// No description provided for @pickResizeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose scale rules'**
  String get pickResizeDialogTitle;

  /// No description provided for @resizeSelector.
  ///
  /// In en, this message translates to:
  /// **'{resize,select, contain{Contain all content}cover{Resize and crop}other{}}'**
  String resizeSelector(String resize);

  /// No description provided for @deleteMovieAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the video?'**
  String get deleteMovieAlertTitle;

  /// No description provided for @deleteMovieAlertPrimary.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get deleteMovieAlertPrimary;

  /// No description provided for @deleteMovieAlertSecondary.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get deleteMovieAlertSecondary;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'project #{projectId}'**
  String projectTitle(int projectId);

  /// No description provided for @draftTitle.
  ///
  /// In en, this message translates to:
  /// **'draft #{projectId}'**
  String draftTitle(int projectId);

  /// No description provided for @failedPlayVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to play your video'**
  String get failedPlayVideo;

  /// No description provided for @previewActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get previewActionShare;

  /// No description provided for @previewActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get previewActionDelete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
