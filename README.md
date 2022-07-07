## SlideMix - movie maker application
Cross platform movie maker.

All UI components for Android and iOS were written in Flutter.
[Shared business logic](https://github.com/feelsoftware/SlideMix/tree/main/android/sharedcode/src/commonMain/kotlin/com/feelsoftware/slidemix "Shared business logic") to create movies and to store data in DB were written in [Kotlin Multiplatform](https://kotlinlang.org/docs/reference/building-mpp-with-gradle.html "Kotlin Multiplatform").

The main [Android](https://github.com/feelsoftware/SlideMix/blob/main/android/app/src/main/kotlin/com/feelsoftware/slidemix/MainActivity.kt "Android") and [iOS](https://github.com/feelsoftware/SlideMix/blob/main/ios/Runner/AppDelegate.swift "iOS") component contains [MethodChannel](https://flutter.dev/docs/development/platform-integration/platform-channels#examplehttp:// "MethodChannel") to invoke logic from [shared module](https://github.com/feelsoftware/SlideMix/tree/main/android/sharedcode/src/commonMain/kotlin/com/feelsoftware/slidemix "shared module").

DB was implemented by [SQLDelight](https://github.com/cashapp/sqldelight "SQLDelight").

Creation movies from images and generate thumbnails for movies were implemented by [mobile-ffmpeg](https://github.com/tanersener/mobile-ffmpeg "mobile-ffmpeg").

[Android](https://github.com/feelsoftware/SlideMix/blob/main/android/app/src/main/kotlin/com/feelsoftware/slidemix/provider/FFmpegProviderImpl.kt "Android") and [iOS](https://github.com/feelsoftware/SlideMix/blob/main/ios/Runner/FFmpegProviderImpl.swift "iOS") have a bridge to communicate with FFmpeg and execute commands to create videos and thumbnails.

The app was launched and verified on LG V20 and iPhone 11 Pro. A created video can't be played on iOS Simulator, only on the real device. Android Emulator has the correct behavior.

------------



### [Welcome screen](https://github.com/feelsoftware/SlideMix/blob/main/lib/welcome/welcome.dart "Welcome screen")
<img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/welcome.png" width="180" height="390" />

Welcome screen with our logo and a button to proceed.


------------



### [Movies list](https://github.com/feelsoftware/SlideMix/blob/main/lib/movies/movies.dart "Movies list")
<img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/movies.png" width="180" height="390" />

Display movies list from DB.
Feature 'Add to favorites' is not implemented yet.



------------



### [Movie creation flow](https://github.com/feelsoftware/SlideMix/tree/main/lib/creation "Movie creation flow")

<img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/create_movie.png" width="180" height="390" /> <img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/create_movie_source.png" width="180" height="390" />

A user chooses some media from Camera or Gallery source for the new movie.


------------


### [Preview screen](https://github.com/feelsoftware/SlideMix/tree/main/lib/preview "Preview screen")

<img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/preview_1.png" width="180" height="390" /> <img src="https://github.com/feelsoftware/SlideMix/raw/main/readme/preview_2.png" width="180" height="390" />

Video's preview. Users have the possibility to preview and delete videos.
