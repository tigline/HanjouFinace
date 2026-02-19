# core_storage

Shared storage abstractions and adapters for Flutter apps.

## Included adapters

- `SecureKeyValueStorage`: sensitive values (tokens, secrets).
- `SharedPrefsKeyValueStorage`: lightweight key/value config.
- `HiveLargeDataStore`: larger structured data cache.

## Bootstrap

Initialize Hive before using `HiveLargeDataStore`:

```dart
await CoreStorageBootstrap.initializeHive();
```
