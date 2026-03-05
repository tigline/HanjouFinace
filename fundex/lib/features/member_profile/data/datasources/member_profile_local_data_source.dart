import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/auth_user_dto.dart';
import '../models/member_profile_details_dto.dart';

abstract class MemberProfileLocalDataSource {
  Future<MemberProfileDetailsDto?> readProfile();
  Future<void> saveProfile(MemberProfileDetailsDto profile);
  Future<void> clearProfile();
}

class MemberProfileLocalDataSourceImpl implements MemberProfileLocalDataSource {
  MemberProfileLocalDataSourceImpl(this._largeDataStore, this._authLocal);

  static const String _profileKeyPrefix = 'member_profile.details';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocal;

  Future<String> _resolveProfileKey() async {
    final AuthUserDto? user = await _authLocal.readCurrentUser();
    final String userScopedKey = _resolveUserStorageKey(user);
    return '$_profileKeyPrefix.$userScopedKey';
  }

  String _resolveUserStorageKey(AuthUserDto? user) {
    if (user == null) {
      return 'anonymous';
    }

    final int? userId = user.userId ?? user.memberId;
    if (userId != null) {
      return 'uid_$userId';
    }

    final String id = user.id?.trim() ?? '';
    if (id.isNotEmpty) {
      return 'id_$id';
    }

    final String accountId = user.accountId?.trim() ?? '';
    if (accountId.isNotEmpty) {
      return 'account_$accountId';
    }

    final String username = user.username.trim();
    if (username.isNotEmpty) {
      return 'username_$username';
    }

    return 'anonymous';
  }

  @override
  Future<void> clearProfile() async {
    try {
      final key = await _resolveProfileKey();
      await _largeDataStore.delete(key);
    } catch (_) {
      // Local profile cache should not block user flows.
    }
  }

  @override
  Future<MemberProfileDetailsDto?> readProfile() async {
    try {
      final key = await _resolveProfileKey();
      final rawValue = await _largeDataStore.get<dynamic>(key);
      if (rawValue == null) {
        return null;
      }

      if (rawValue is String) {
        if (rawValue.trim().isEmpty) {
          return null;
        }
        final decoded = jsonDecode(rawValue);
        if (decoded is Map<String, dynamic>) {
          return MemberProfileDetailsDto.fromJson(decoded);
        }
        if (decoded is Map) {
          return MemberProfileDetailsDto.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
        return null;
      }

      if (rawValue is Map<String, dynamic>) {
        return MemberProfileDetailsDto.fromJson(rawValue);
      }
      if (rawValue is Map) {
        return MemberProfileDetailsDto.fromJson(
          Map<String, dynamic>.from(rawValue),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProfile(MemberProfileDetailsDto profile) async {
    try {
      final key = await _resolveProfileKey();
      await _largeDataStore.put<String>(key, jsonEncode(profile.toJson()));
    } catch (_) {
      // Keep profile intake flow usable even when local storage write fails.
    }
  }
}
