import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum AppLogLevel { debug, info, warning, error }

abstract class AppLogger {
  void log(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context,
  });

  void debug(String message, {Map<String, Object?> context});
  void info(String message, {Map<String, Object?> context});
  void warning(String message, {Map<String, Object?> context});
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context,
  });

  Future<List<File>> listLogFiles();

  Future<File> exportLogs({Directory? outputDirectory});

  Future<void> dispose();
}

class FileAppLogger implements AppLogger {
  FileAppLogger._({
    required Logger logger,
    required Directory logDirectory,
    required bool enableDebugLogs,
    required bool enableConsoleOutput,
    required String filePrefix,
    required int retentionDays,
    required DateTime Function() now,
  }) : _logger = logger,
       _logDirectory = logDirectory,
       _enableDebugLogs = enableDebugLogs,
       _enableConsoleOutput = enableConsoleOutput,
       _filePrefix = filePrefix,
       _retentionDays = retentionDays,
       _now = now {
    hierarchicalLoggingEnabled = true;
    _logger.level = _enableDebugLogs ? Level.ALL : Level.INFO;
    _recordSubscription = _logger.onRecord.listen(_onRecord);
  }

  static Future<FileAppLogger> create({
    required bool enableDebugLogs,
    String loggerName = 'app',
    bool enableConsoleOutput = true,
    String directoryName = 'logs',
    String filePrefix = 'app-log',
    int retentionDays = 7,
    Directory? logDirectory,
    DateTime Function()? now,
  }) async {
    final resolvedDirectory =
        logDirectory ?? await _resolveDefaultLogDirectory(directoryName);
    await resolvedDirectory.create(recursive: true);

    final logger = FileAppLogger._(
      logger: Logger(loggerName),
      logDirectory: resolvedDirectory,
      enableDebugLogs: enableDebugLogs,
      enableConsoleOutput: enableConsoleOutput,
      filePrefix: filePrefix,
      retentionDays: retentionDays,
      now: now ?? DateTime.now,
    );

    await logger._rotateSinkIfNeeded();
    await logger._cleanupOldLogFiles();
    return logger;
  }

  final Logger _logger;
  final Directory _logDirectory;
  final bool _enableDebugLogs;
  final bool _enableConsoleOutput;
  final String _filePrefix;
  final int _retentionDays;
  final DateTime Function() _now;

  late final StreamSubscription<LogRecord> _recordSubscription;
  Future<void> _pendingWrites = Future<void>.value();
  IOSink? _sink;
  String? _activeDateKey;
  bool _isClosing = false;
  bool _isDisposed = false;

  @override
  void debug(String message, {Map<String, Object?> context = const {}}) {
    log(AppLogLevel.debug, message, context: context);
  }

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    log(AppLogLevel.info, message, context: context);
  }

  @override
  void warning(String message, {Map<String, Object?> context = const {}}) {
    log(AppLogLevel.warning, message, context: context);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    log(
      AppLogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  @override
  void log(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    if (_isClosing || _isDisposed) {
      return;
    }

    final formatted = context.isEmpty ? message : '$message context=$context';
    switch (level) {
      case AppLogLevel.debug:
        _logger.fine(formatted);
      case AppLogLevel.info:
        _logger.info(formatted);
      case AppLogLevel.warning:
        _logger.warning(formatted);
      case AppLogLevel.error:
        _logger.log(Level.SEVERE, formatted, error, stackTrace);
    }
  }

  @override
  Future<List<File>> listLogFiles() async {
    final files = <File>[];
    await for (final entity in _logDirectory.list()) {
      if (entity is! File) {
        continue;
      }
      final basename = p.basename(entity.path);
      if (_isAppLogFileName(basename)) {
        files.add(entity);
      }
    }
    files.sort((a, b) => a.path.compareTo(b.path));
    return files;
  }

  @override
  Future<File> exportLogs({Directory? outputDirectory}) async {
    await _pendingWrites;
    if (!_isDisposed) {
      await _sink?.flush();
    }

    final files = await listLogFiles();
    final exportDirectory =
        outputDirectory ?? Directory(p.join(_logDirectory.path, 'exports'));
    await exportDirectory.create(recursive: true);

    final timestamp = _now().toIso8601String().replaceAll(':', '-');
    final exportFile = File(
      p.join(exportDirectory.path, '${_filePrefix}-export-$timestamp.txt'),
    );

    final sink = exportFile.openWrite(mode: FileMode.writeOnly);
    for (final file in files) {
      sink.writeln('===== ${p.basename(file.path)} =====');
      if (await file.exists()) {
        sink.writeln(await file.readAsString());
      }
      sink.writeln('');
    }
    await sink.flush();
    await sink.close();

    return exportFile;
  }

  @override
  Future<void> dispose() async {
    if (_isClosing || _isDisposed) {
      return;
    }
    _isClosing = true;
    await _recordSubscription.cancel();
    await _pendingWrites;
    await _sink?.flush();
    await _sink?.close();
    _isDisposed = true;
  }

  static Future<Directory> _resolveDefaultLogDirectory(
    String directoryName,
  ) async {
    final support = await getApplicationSupportDirectory();
    return Directory(p.join(support.path, directoryName));
  }

  void _onRecord(LogRecord record) {
    if (_isClosing || _isDisposed) {
      return;
    }
    _pendingWrites = _pendingWrites.then((_) => _writeRecord(record));
  }

  Future<void> _writeRecord(LogRecord record) async {
    if (_isDisposed) {
      return;
    }

    try {
      await _rotateSinkIfNeeded();

      final timestamp = record.time.toUtc().toIso8601String();
      final levelLabel = record.level.name;
      final line = '[$timestamp][$levelLabel] ${record.message}';

      _sink?.writeln(line);
      if (record.error != null) {
        _sink?.writeln('error=${record.error}');
      }
      if (record.stackTrace != null) {
        _sink?.writeln('stackTrace=${record.stackTrace}');
      }
      await _sink?.flush();

      if (_enableConsoleOutput) {
        // ignore: avoid_print
        print(line);
        if (record.error != null) {
          // ignore: avoid_print
          print('error=${record.error}');
        }
        if (record.stackTrace != null) {
          // ignore: avoid_print
          print('stackTrace=${record.stackTrace}');
        }
      }
    } catch (error, stackTrace) {
      if (_enableConsoleOutput) {
        // ignore: avoid_print
        print('File logger write failed: $error');
        // ignore: avoid_print
        print(stackTrace);
      }
    }
  }

  Future<void> _rotateSinkIfNeeded() async {
    final dateKey = _dateKey(_now());
    if (_activeDateKey == dateKey && _sink != null) {
      return;
    }

    await _sink?.flush();
    await _sink?.close();

    _activeDateKey = dateKey;
    final activeLogFile = File(
      p.join(_logDirectory.path, '$_filePrefix-$dateKey.log'),
    );
    _sink = activeLogFile.openWrite(mode: FileMode.append);
  }

  Future<void> _cleanupOldLogFiles() async {
    if (_retentionDays < 1) {
      return;
    }

    final thresholdDate = _now().toUtc().subtract(
      Duration(days: _retentionDays),
    );
    final files = await listLogFiles();
    for (final file in files) {
      final basename = p.basename(file.path);
      final date = _dateFromFileName(basename);
      if (date == null) {
        continue;
      }
      if (date.isBefore(
        DateTime.utc(
          thresholdDate.year,
          thresholdDate.month,
          thresholdDate.day,
        ),
      )) {
        await file.delete();
      }
    }
  }

  bool _isAppLogFileName(String basename) {
    return basename.startsWith('$_filePrefix-') && basename.endsWith('.log');
  }

  String _dateKey(DateTime time) {
    final utc = time.toUtc();
    final month = utc.month.toString().padLeft(2, '0');
    final day = utc.day.toString().padLeft(2, '0');
    return '${utc.year}-$month-$day';
  }

  DateTime? _dateFromFileName(String basename) {
    final prefix = '$_filePrefix-';
    if (!basename.startsWith(prefix) || !basename.endsWith('.log')) {
      return null;
    }

    final dateSegment = basename.substring(prefix.length, basename.length - 4);
    final parsed = DateTime.tryParse(dateSegment);
    if (parsed == null) {
      return null;
    }

    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }
}
