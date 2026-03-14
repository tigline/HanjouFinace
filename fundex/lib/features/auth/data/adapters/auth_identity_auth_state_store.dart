import 'dart:convert';

import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_storage/core_storage.dart';

import '../datasources/auth_local_data_source.dart';

class AuthIdentityAuthStateStore implements IdentityAuthStateStore {
  AuthIdentityAuthStateStore({
    required LargeDataStore largeDataStore,
    required AuthLocalDataSource authLocalDataSource,
  }) : _largeDataStore = largeDataStore,
       _authLocalDataSource = authLocalDataSource;

  static const String _snapshotStoragePrefix = 'identity_auth.snapshot';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<IdentityAuthSnapshot> readSnapshot() async {
    final storageKey = await _resolveStorageKey();
    if (storageKey == null) {
      return const IdentityAuthSnapshot(
        realPersonVerified: false,
        currentDeviceBiometricEnabled: false,
      );
    }

    try {
      final raw = await _largeDataStore.get<dynamic>(storageKey);
      final payload = _toJsonMap(raw);
      if (payload.isEmpty) {
        return const IdentityAuthSnapshot(
          realPersonVerified: false,
          currentDeviceBiometricEnabled: false,
        );
      }
      return IdentityAuthSnapshot(
        realPersonVerified:
            payload['realPersonVerified'] == true ||
            payload['realPersonVerified']?.toString().trim() == '1',
        currentDeviceBiometricEnabled:
            payload['currentDeviceBiometricEnabled'] == true ||
            payload['currentDeviceBiometricEnabled']?.toString().trim() == '1',
      );
    } catch (_) {
      return const IdentityAuthSnapshot(
        realPersonVerified: false,
        currentDeviceBiometricEnabled: false,
      );
    }
  }

  @override
  Future<void> writeSnapshot(IdentityAuthSnapshot snapshot) async {
    final storageKey = await _resolveStorageKey();
    if (storageKey == null) {
      return;
    }

    final payload = <String, dynamic>{
      'realPersonVerified': snapshot.realPersonVerified,
      'currentDeviceBiometricEnabled': snapshot.currentDeviceBiometricEnabled,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _largeDataStore.put<String>(storageKey, jsonEncode(payload));
    } catch (_) {
      // Keep auth flows available even when local snapshot write fails.
    }
  }

  Future<String?> _resolveStorageKey() async {
    final user = await _authLocalDataSource.readCurrentUser();
    if (user == null) {
      return null;
    }

    final scope =
        user.userId?.toString() ??
        user.memberId?.toString() ??
        user.username.trim();
    final normalized = scope.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return '$_snapshotStoragePrefix.$normalized';
  }

  Map<String, dynamic> _toJsonMap(dynamic raw) {
    if (raw == null) {
      return <String, dynamic>{};
    }
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String) {
      final text = raw.trim();
      if (text.isEmpty) {
        return <String, dynamic>{};
      }
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }
}
