import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../models/member_profile_details_dto.dart';

abstract class MemberProfileLocalDataSource {
  Future<MemberProfileDetailsDto?> readProfile();
  Future<void> saveProfile(MemberProfileDetailsDto profile);
  Future<void> clearProfile();
}

class MemberProfileLocalDataSourceImpl implements MemberProfileLocalDataSource {
  MemberProfileLocalDataSourceImpl(this._largeDataStore);

  static const String _profileKey = 'member_profile.details';

  final LargeDataStore _largeDataStore;

  @override
  Future<void> clearProfile() async {
    try {
      await _largeDataStore.delete(_profileKey);
    } catch (_) {
      // Local profile cache should not block user flows.
    }
  }

  @override
  Future<MemberProfileDetailsDto?> readProfile() async {
    try {
      final rawValue = await _largeDataStore.get<dynamic>(_profileKey);
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
      await _largeDataStore.put<String>(
        _profileKey,
        jsonEncode(profile.toJson()),
      );
    } catch (_) {
      // Keep profile intake flow usable even when local storage write fails.
    }
  }
}
