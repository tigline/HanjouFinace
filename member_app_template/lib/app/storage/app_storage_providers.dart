import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureKeyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  return SecureKeyValueStorage();
});

final sharedPrefsStorageProvider = Provider<KeyValueStorage>((ref) {
  return SharedPrefsKeyValueStorage(namespace: 'member_app');
});

final largeDataStoreProvider = Provider<LargeDataStore>((ref) {
  return HiveLargeDataStore(boxName: 'member_app_large_data');
});
