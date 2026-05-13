import 'dart:developer' as developer;

import 'package:clipboard/utils/utility.dart';
import 'package:flutter/foundation.dart';

// MARK: - Types

enum LogLevel { debug, info, warning, error }

typedef LogMessageBuilder = Object? Function();

// MARK: - Configuration

class LoggingConfig {
  LoggingConfig._();

  static bool enabled = !kReleaseMode;
  static LogLevel minimumLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;
  static bool useAnsiColors = kDebugMode;
  static bool captureErrorStackTraces = kDebugMode;
  static bool showScope = true;

  static void configure({
    bool? enabled,
    LogLevel? minimumLevel,
    bool? useAnsiColors,
    bool? captureErrorStackTraces,
    bool? showScope,
  }) {
    if (enabled != null) {
      LoggingConfig.enabled = enabled;
    }
    if (minimumLevel != null) {
      LoggingConfig.minimumLevel = minimumLevel;
    }
    if (useAnsiColors != null) {
      LoggingConfig.useAnsiColors = useAnsiColors;
    }
    if (captureErrorStackTraces != null) {
      LoggingConfig.captureErrorStackTraces = captureErrorStackTraces;
    }
    if (showScope != null) {
      LoggingConfig.showScope = showScope;
    }
  }
}

// MARK: - Logger

class AppLogger {
  AppLogger({String? scope}) : _scope = scope;

  final String? _scope;

  const AppLogger.scoped(String scope) : _scope = scope;

  // MARK: - State

  bool get isEnabled => LoggingConfig.enabled;

  bool isEnabledFor(LogLevel level) => _shouldLog(level);

  bool _shouldLog(LogLevel level) {
    return LoggingConfig.enabled &&
        level.index >= LoggingConfig.minimumLevel.index;
  }

  // MARK: - API

  void d(Object? message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  void i(Object? message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  void w(Object? message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  void e(Object? message, {Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(LogLevel.error)) return;

    _log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: _resolveErrorStackTrace(message, error, stackTrace),
    );
  }

  // MARK: - Internals

  void _log(
    LogLevel level,
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog(level)) return;

    final resolvedMessage = _withScope(
      level,
      _resolveMessage(message)?.toString() ?? '',
    );
    final payload = _colorize(resolvedMessage, _messageColor(level));

    developer.log(
      payload,
      level: _levelValue(level),
      name: 'CC',
      error: error,
      stackTrace: stackTrace,
      time: systemTime(),
    );
  }

  // MARK: - Message Resolution

  Object? _resolveMessage(Object? message) {
    return switch (message) {
      LogMessageBuilder build => build(),
      _ => message,
    };
  }

  String _withScope(LogLevel level, String message) {
    // MARK: - Formatting
    if (!LoggingConfig.showScope || _scope == null || _scope.isEmpty) {
      return '[${level.name}] $message';
    }
    if (message.isEmpty) {
      return '[${level.name}][$_scope]';
    }
    return '[${level.name}][$_scope] $message';
  }

  StackTrace? _resolveErrorStackTrace(
    Object? message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (stackTrace != null) {
      return stackTrace;
    }
    if (!LoggingConfig.captureErrorStackTraces) {
      return null;
    }

    final stackTraceFromObject = switch (error ?? message) {
      Error value => value.stackTrace,
      _ => null,
    };

    return stackTraceFromObject ?? StackTrace.current;
  }

  String _colorize(String text, String colorCode) {
    if (!kDebugMode || !LoggingConfig.useAnsiColors) {
      return text;
    }
    if (text.isEmpty || colorCode.isEmpty) {
      return text;
    }
    return '$colorCode$text\x1b[0m';
  }

  String _messageColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1b[90m';
      case LogLevel.info:
        return '';
      case LogLevel.warning:
        return '\x1b[1;33m';
      case LogLevel.error:
        return '\x1b[1;31m';
    }
  }

  int _levelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}

// MARK: - Shared Instance

final logger = AppLogger();
