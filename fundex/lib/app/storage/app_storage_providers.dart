import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureKeyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  return SecureKeyValueStorage();
});

final sharedPrefsStorageProvider = Provider<KeyValueStorage>((ref) {
  return SharedPrefsKeyValueStorage(namespace: 'StellaVia');
});

final largeDataStoreProvider = Provider<LargeDataStore>((ref) {
  return HiveLargeDataStore(boxName: 'StellaVia_large_data');
});
