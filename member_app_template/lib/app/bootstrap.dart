import 'package:core_storage/core_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/app_environment.dart';
import 'config/app_flavor.dart';
import 'config/environment_provider.dart';

bool? _parseOptionalBool(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }
  if (normalized == 'true') {
    return true;
  }
  if (normalized == 'false') {
    return false;
  }
  return null;
}

Future<void> bootstrap({
  required AppFlavor flavor,
  String? memberApiBaseUrlOverride,
  String? hotelApiBaseUrlOverride,
  String? oaApiBaseUrlOverride,
  String? swaggerUiUrlOverride,
  bool? enableHttpLogOverride,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreStorageBootstrap.initializeHive();

  const enableHttpLogDefine = String.fromEnvironment('ENABLE_HTTP_LOG');
  final enableHttpLogFromDefine = _parseOptionalBool(enableHttpLogDefine);

  final environment = EnvironmentFactory.fromFlavor(
    flavor,
    memberApiBaseUrlOverride:
        memberApiBaseUrlOverride ??
        const String.fromEnvironment('API_BASE_URL'),
    hotelApiBaseUrlOverride:
        hotelApiBaseUrlOverride ??
        const String.fromEnvironment('HOTEL_API_BASE_URL'),
    oaApiBaseUrlOverride:
        oaApiBaseUrlOverride ?? const String.fromEnvironment('OA_API_BASE_URL'),
    swaggerUiUrlOverride:
        swaggerUiUrlOverride ?? const String.fromEnvironment('SWAGGER_UI_URL'),
    enableHttpLogOverride: enableHttpLogOverride ?? enableHttpLogFromDefine,
  );

  runApp(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
      ],
      child: const MemberTemplateApp(),
    ),
  );
}
