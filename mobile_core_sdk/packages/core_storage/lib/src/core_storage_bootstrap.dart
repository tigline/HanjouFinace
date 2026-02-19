import 'package:hive_flutter/hive_flutter.dart';

class CoreStorageBootstrap {
  static bool _hiveInitialized = false;

  static Future<void> initializeHive({String? subDir}) async {
    if (_hiveInitialized) {
      return;
    }

    await Hive.initFlutter(subDir);
    _hiveInitialized = true;
  }
}
