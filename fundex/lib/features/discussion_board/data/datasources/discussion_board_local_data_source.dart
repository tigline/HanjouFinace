import 'dart:convert';

import 'package:core_storage/core_storage.dart';

import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/auth_user_dto.dart';
import '../../domain/entities/discussion_board_models.dart';

abstract class DiscussionBoardLocalDataSource {
  Future<List<DiscussionThread>> readThreads();
  Future<void> saveThreads(List<DiscussionThread> threads);
  Future<void> clearThreads();
}

class DiscussionBoardLocalDataSourceImpl
    implements DiscussionBoardLocalDataSource {
  DiscussionBoardLocalDataSourceImpl(
    this._largeDataStore,
    this._authLocal, {
    this.projectId,
  });

  static const String _threadsKeyPrefix = 'discussion_board.threads';

  final LargeDataStore _largeDataStore;
  final AuthLocalDataSource _authLocal;
  final int? projectId;

  Future<String> _resolveStorageKey() async {
    final AuthUserDto? user = await _authLocal.readCurrentUser();
    final userScopedKey = _resolveUserStorageKey(user);
    final feedScopedKey = _resolveFeedStorageKey(projectId);
    return '$_threadsKeyPrefix.$userScopedKey.$feedScopedKey';
  }

  String _resolveFeedStorageKey(int? projectId) {
    if (projectId == null) {
      return 'global';
    }
    return 'project_$projectId';
  }

  String _resolveUserStorageKey(AuthUserDto? user) {
    if (user == null) {
      return 'anonymous';
    }
    final int? uid = user.userId ?? user.memberId;
    if (uid != null) {
      return 'uid_$uid';
    }
    final id = user.id?.trim() ?? '';
    if (id.isNotEmpty) {
      return 'id_$id';
    }
    final accountId = user.accountId?.trim() ?? '';
    if (accountId.isNotEmpty) {
      return 'account_$accountId';
    }
    final username = user.username.trim();
    if (username.isNotEmpty) {
      return 'username_$username';
    }
    return 'anonymous';
  }

  @override
  Future<void> clearThreads() async {
    try {
      final key = await _resolveStorageKey();
      await _largeDataStore.delete(key);
    } catch (_) {
      // Ignore local cache failures to avoid blocking UI flows.
    }
  }

  @override
  Future<List<DiscussionThread>> readThreads() async {
    try {
      final key = await _resolveStorageKey();
      final raw = await _largeDataStore.get<dynamic>(key);
      if (raw == null) {
        return const <DiscussionThread>[];
      }

      if (raw is String) {
        final text = raw.trim();
        if (text.isEmpty) {
          return const <DiscussionThread>[];
        }
        final decoded = jsonDecode(text);
        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map(
                (Map item) =>
                    DiscussionThread.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(growable: false);
        }
      }

      if (raw is List) {
        return raw
            .whereType<Map>()
            .map(
              (Map item) =>
                  DiscussionThread.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList(growable: false);
      }

      return const <DiscussionThread>[];
    } catch (_) {
      return const <DiscussionThread>[];
    }
  }

  @override
  Future<void> saveThreads(List<DiscussionThread> threads) async {
    try {
      final key = await _resolveStorageKey();
      final payload = threads
          .map((DiscussionThread item) => item.toJson())
          .toList(growable: false);
      await _largeDataStore.put<String>(key, jsonEncode(payload));
    } catch (_) {
      // Ignore local cache failures to keep posting UI available.
    }
  }
}
