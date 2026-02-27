import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureKeyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  return SecureKeyValueStorage();
});

final sharedPrefsStorageProvider = Provider<KeyValueStorage>((ref) {
  return SharedPrefsKeyValueStorage(namespace: 'fundex');
});

final largeDataStoreProvider = Provider<LargeDataStore>((ref) {
  return HiveLargeDataStore(boxName: 'fundex_large_data');
});
