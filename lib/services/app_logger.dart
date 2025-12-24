import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Log levels for filtering and categorizing logs
enum LogLevel {
  verbose, // Most detailed, for debugging internals
  debug,   // Development debugging
  info,    // Important events
  warning, // Potential issues
  error,   // Errors that need attention
}

/// Centralized logging service for the Finovate app.
///
/// Features:
/// - Log levels for filtering (verbose, debug, info, warning, error)
/// - Production filtering (only warning/error in release builds)
/// - Tag-based module identification
/// - Pretty-printed output with visual distinction
/// - Optional error/stackTrace support
///
/// Usage:
/// ```dart
/// AppLogger.info('User logged in', tag: 'AuthService');
/// AppLogger.error('API failed', error: e, stackTrace: stack, tag: 'ApiService');
/// AppLogger.verbose('Response: $data', tag: 'Network');
/// ```
class AppLogger {
  AppLogger._();

  /// Minimum log level for output
  /// In release mode, only warning and error are logged
  static LogLevel _minLevel = kReleaseMode ? LogLevel.warning : LogLevel.verbose;

  /// Configure minimum log level (useful for testing)
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Log a verbose message (detailed debug info)
  /// Use for: network payloads, state changes, detailed flow tracing
  static void verbose(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.verbose, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message (development debugging)
  /// Use for: general debugging during development
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log an info message (important events)
  /// Use for: navigation, user actions, significant state changes
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message (potential issues)
  /// Use for: deprecated usage, fallback behavior, recoverable issues
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Log an error message (errors that need attention)
  /// Use for: exceptions, failed operations, critical issues
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip if below minimum level
    if (level.index < _minLevel.index) return;

    final emoji = _getEmoji(level);
    final levelName = _getLevelName(level);
    final tagPrefix = tag != null ? '[$tag] ' : '';
    final formattedMessage = '$emoji $levelName: $tagPrefix$message';

    // Use dart:developer log for better integration with DevTools
    developer.log(
      formattedMessage,
      name: tag ?? 'Finovate',
      level: _getDeveloperLogLevel(level),
      error: error,
      stackTrace: stackTrace,
    );

    // Also print in debug mode for console visibility
    if (kDebugMode) {
      // ignore: avoid_print
      print(formattedMessage);
      if (error != null) {
        // ignore: avoid_print
        print('  Error: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('  StackTrace: $stackTrace');
      }
    }
  }

  /// Get emoji for visual distinction
  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '📝';
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  /// Get level name string
  static String _getLevelName(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 'VERBOSE';
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
    }
  }

  /// Map to dart:developer log levels
  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 500;
      case LogLevel.debug:
        return 700;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
