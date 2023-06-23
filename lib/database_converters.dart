import 'package:floor/floor.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/extensions/iterable.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class DurationConverter extends TypeConverter<Duration, int> {
  @override
  Duration decode(int databaseValue) {
    return Duration(milliseconds: databaseValue);
  }

  @override
  int encode(Duration value) {
    return value.inMilliseconds;
  }
}

class SlideShowTransitionConverter
    extends TypeConverter<SlideShowTransition?, String?> {
  @override
  SlideShowTransition? decode(String? databaseValue) {
    return SlideShowTransition.values.firstOrNull((e) => e.name == databaseValue);
  }

  @override
  String encode(SlideShowTransition? value) {
    return value?.name ?? '';
  }
}

class SlideShowOrientationConverter
    extends TypeConverter<SlideShowOrientation, String?> {
  @override
  SlideShowOrientation decode(String? databaseValue) {
    return SlideShowOrientation.values.firstOrNull((e) => e.name == databaseValue) ??
        SlideShowOrientation.landscape;
  }

  @override
  String? encode(SlideShowOrientation value) {
    return value.name;
  }
}

class SlideShowResizeConverter extends TypeConverter<SlideShowResize, String?> {
  @override
  SlideShowResize decode(String? databaseValue) {
    return SlideShowResize.values.firstOrNull((e) => e.name == databaseValue) ??
        SlideShowResize.contain;
  }

  @override
  String? encode(SlideShowResize value) {
    return value.name;
  }
}
