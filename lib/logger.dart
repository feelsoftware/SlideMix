import 'package:logger/logger.dart' as logger_impl;

class Logger {
  static final logger_impl.Logger _loggerImpl = logger_impl.Logger();

  Logger._();

  static void d(String message) {
    _loggerImpl.d(message);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _loggerImpl.e(message, error, stackTrace);
  }
}
