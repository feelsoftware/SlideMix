## CPMovieMaker
Cross platform movie maker.

All UI components for Android and iOS were written in Flutter.
[Shared business logic](https://github.com/vitoksmile/CPMovieMaker/tree/master/android/sharedcode/src/commonMain/kotlin/com/vitoksmile/cpmoviemaker "Shared business logic") to create movies and to store data in DB were written in [Kotlin Multiplatform](https://kotlinlang.org/docs/reference/building-mpp-with-gradle.html "Kotlin Multiplatform").

The main [Android](https://github.com/vitoksmile/CPMovieMaker/blob/master/android/app/src/main/kotlin/com/vitoksmile/cpmoviemaker/MainActivity.kt "Android") and [iOS](https://github.com/vitoksmile/CPMovieMaker/blob/master/ios/Runner/AppDelegate.swift "iOS") component contains [MethodChannel](https://flutter.dev/docs/development/platform-integration/platform-channels#examplehttp:// "MethodChannel") to invoke logic from [shared module](https://github.com/vitoksmile/CPMovieMaker/tree/master/android/sharedcode/src/commonMain/kotlin/com/vitoksmile/cpmoviemaker "shared module").

DB was implemented by [SQLDelight](https://github.com/cashapp/sqldelight "SQLDelight").

Creation movies from images and generate thumbnails for movies were implemented by [mobile-ffmpeg](https://github.com/tanersener/mobile-ffmpeg "mobile-ffmpeg").

[Android](https://github.com/vitoksmile/CPMovieMaker/blob/readme/android/app/src/main/kotlin/com/vitoksmile/cpmoviemaker/provider/FFmpegProviderImpl.kt "Android") and [iOS](https://github.com/vitoksmile/CPMovieMaker/blob/readme/ios/Runner/FFmpegProviderImpl.swift "iOS") have a bridge to communicate with FFmpeg and execute commands to create videos and thumbnails.

The app was launched on LG V20 and iPhone 11 Pro. A created video can't be played on iOS Simulator. Android Emulator has a correct behaviour.

[Watch the app's video review.](https://youtu.be/cfo99vDoo38 "Watch the app's video review.")

------------



### [Movies screen](https://github.com/vitoksmile/CPMovieMaker/blob/master/lib/movies/movies.dart "Movies screen")
<img src="https://github.com/vitoksmile/CPMovieMaker/raw/master/readme/main.png" width="180" height="370" />

Display list of movies from DB.


------------



### [Create a movie screen](https://github.com/vitoksmile/CPMovieMaker/tree/master/lib/creation "Create a movie screen")

<img src="https://github.com/vitoksmile/CPMovieMaker/raw/master/readme/create_movie.png" width="180" height="370" /> <img src="https://github.com/vitoksmile/CPMovieMaker/raw/master/readme/create_movie_source.png" width="180" height="370" />

A user chooses some media from Camera or Gallery source for a new movie.


------------


### [Preview screen](https://github.com/vitoksmile/CPMovieMaker/tree/master/lib/preview "Preview screen")

<img src="https://github.com/vitoksmile/CPMovieMaker/raw/master/readme/preview.png" width="180" height="370" />

Simple video's preview.


------------


### Actions on Preview screen (not implemented)

<img src="https://github.com/vitoksmile/CPMovieMaker/raw/master/readme/preview_actions.png" width="180" height="370" />

A user can share the created movie or does some simple actions (duplicate, rename, delete).