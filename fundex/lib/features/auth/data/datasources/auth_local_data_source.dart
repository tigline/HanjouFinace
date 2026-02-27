import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../models/auth_user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCurrentUser(AuthUserDto user);
  Future<AuthUserDto?> readCurrentUser();
  Future<void> clearCurrentUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._largeDataStore);

  static const String _currentUserKey = 'auth.current_user';

  final LargeDataStore _largeDataStore;

  @override
  Future<void> clearCurrentUser() async {
    try {
      await _largeDataStore.delete(_currentUserKey);
    } catch (_) {
      // Do not block auth flows when Hive is unavailable in tests/edge cases.
    }
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async {
    try {
      final rawValue = await _largeDataStore.get<dynamic>(_currentUserKey);
      if (rawValue == null) {
        return null;
      }

      if (rawValue is String) {
        if (rawValue.trim().isEmpty) {
          return null;
        }
        final decoded = jsonDecode(rawValue);
        if (decoded is Map<String, dynamic>) {
          return AuthUserDto.fromJson(decoded);
        }
        if (decoded is Map) {
          return AuthUserDto.fromJson(Map<String, dynamic>.from(decoded));
        }
        return null;
      }

      if (rawValue is Map<String, dynamic>) {
        return AuthUserDto.fromJson(rawValue);
      }
      if (rawValue is Map) {
        return AuthUserDto.fromJson(Map<String, dynamic>.from(rawValue));
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    try {
      await _largeDataStore.put<String>(
        _currentUserKey,
        jsonEncode(user.toJson()),
      );
    } catch (_) {
      // Token login should not fail when local profile cache write fails.
    }
  }
}
