import 'package:core_storage/core_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreStorageBootstrap.initializeHive();
  runApp(const ProviderScope(child: MemberTemplateApp()));
}
