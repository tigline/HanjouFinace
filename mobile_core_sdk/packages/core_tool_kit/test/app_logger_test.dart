import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:path/path.dart' as p;

void main() {
  group('FileAppLogger', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('core_tool_kit_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('writes records into daily log files', () async {
      final logger = await FileAppLogger.create(
        enableDebugLogs: true,
        enableConsoleOutput: false,
        logDirectory: tempDir,
      );

      logger.info('hello');
      logger.error('boom', error: StateError('x'));
      await logger.dispose();

      final files = await logger.listLogFiles();
      expect(files, isNotEmpty);

      final content = await files.first.readAsString();
      expect(content, contains('hello'));
      expect(content, contains('boom'));
      expect(content, contains('error=Bad state: x'));
    });

    test('exports collected logs into one file', () async {
      final logger = await FileAppLogger.create(
        enableDebugLogs: true,
        enableConsoleOutput: false,
        logDirectory: tempDir,
      );

      logger.info('line-a');
      logger.warning('line-b');

      final exportDir = Directory(p.join(tempDir.path, 'exports-out'));
      final exported = await logger.exportLogs(outputDirectory: exportDir);

      expect(await exported.exists(), isTrue);
      final content = await exported.readAsString();
      expect(content, contains('line-a'));
      expect(content, contains('line-b'));

      await logger.dispose();
    });

    test('cleans files older than retention days on create', () async {
      final old = File(p.join(tempDir.path, 'app-log-2000-01-01.log'));
      await old.writeAsString('old log');

      final logger = await FileAppLogger.create(
        enableDebugLogs: true,
        enableConsoleOutput: false,
        logDirectory: tempDir,
        retentionDays: 1,
        now: () => DateTime.utc(2026, 2, 20),
      );

      expect(await old.exists(), isFalse);

      await logger.dispose();
    });
  });
}
