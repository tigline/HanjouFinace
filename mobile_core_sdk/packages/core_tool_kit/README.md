# core_tool_kit

Shared app tooling utilities.

## Features

- `AppLogger` abstraction for app-level logging.
- `FileAppLogger` implementation based on package `logging`.
- Daily log files.
- Log export to a single text file for sharing/upload.

## Quick usage

```dart
final logger = await FileAppLogger.create(
  enableDebugLogs: true,
  loggerName: 'member_app_template',
);

logger.info('app started');
final exported = await logger.exportLogs();
```
