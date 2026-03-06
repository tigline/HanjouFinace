import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/auth_user_dto.dart';
import '../datasources/discussion_board_local_data_source.dart';
import '../../domain/entities/discussion_board_models.dart';
import '../../domain/repositories/discussion_board_repository.dart';
import '../../presentation/support/discussion_board_mock_seed.dart';

class DiscussionBoardRepositoryImpl implements DiscussionBoardRepository {
  DiscussionBoardRepositoryImpl({
    required DiscussionBoardLocalDataSource local,
    required AuthLocalDataSource authLocal,
  }) : _local = local,
       _authLocal = authLocal;

  final DiscussionBoardLocalDataSource _local;
  final AuthLocalDataSource _authLocal;

  @override
  Future<List<DiscussionThread>> loadThreads() async {
    final cached = await _local.readThreads();
    if (cached.isNotEmpty) {
      return cached;
    }

    final seeded = buildDiscussionBoardMockSeed();
    await _local.saveThreads(seeded);
    final persisted = await _local.readThreads();
    return persisted.isNotEmpty ? persisted : seeded;
  }

  @override
  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return loadThreads();
    }

    final current = await loadThreads();
    final author = await _resolveCurrentAuthor(
      fallbackName: fallbackName,
      fallbackHandle: fallbackHandle,
      fallbackBadgeLabel: fallbackBadgeLabel,
    );
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final updated = <DiscussionThread>[
      DiscussionThread(
        id: 'thread_${DateTime.now().microsecondsSinceEpoch}',
        author: author,
        timeLabel: nowLabel,
        body: trimmed,
        createdAtIso: nowIso,
        commentCount: 0,
        replies: const <DiscussionReply>[],
      ),
      ...current,
    ];

    await _local.saveThreads(updated);
    final persisted = await _local.readThreads();
    return persisted.isNotEmpty ? persisted : updated;
  }

  @override
  Future<List<DiscussionThread>> submitReply({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return loadThreads();
    }

    final current = await loadThreads();
    final author = await _resolveCurrentAuthor(
      fallbackName: fallbackName,
      fallbackHandle: fallbackHandle,
      fallbackBadgeLabel: fallbackBadgeLabel,
    );
    final nowIso = DateTime.now().toUtc().toIso8601String();

    final updated = current
        .map((DiscussionThread thread) {
          if (thread.id != threadId) {
            return thread;
          }
          final reply = DiscussionReply(
            id: 'reply_${DateTime.now().microsecondsSinceEpoch}',
            author: author.copyWith(
              displayName: _shortenToHandle(author.displayName),
              accountHandle: '',
              badge: const DiscussionAuthorBadge(
                label: '',
                backgroundColorValue: 0x00000000,
                foregroundColorValue: 0x00000000,
              ),
            ),
            timeLabel: nowLabel,
            body: trimmed,
            createdAtIso: nowIso,
          );
          return thread.copyWith(
            commentCount: thread.commentCount + 1,
            replies: <DiscussionReply>[...thread.replies, reply],
          );
        })
        .toList(growable: false);

    await _local.saveThreads(updated);
    final persisted = await _local.readThreads();
    return persisted.isNotEmpty ? persisted : updated;
  }

  Future<DiscussionAuthor> _resolveCurrentAuthor({
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final AuthUserDto? user = await _authLocal.readCurrentUser();
    final username = (user?.username ?? '').trim();
    final account = (user?.email ?? user?.accountId ?? '').trim();
    final userId = user?.userId?.toString() ?? user?.id ?? username;

    final displayName = _maskUserName(username, fallbackName);
    final handle = account.isEmpty ? fallbackHandle : _maskAccount(account);
    final avatarText = _firstVisibleCharacter(displayName);

    return DiscussionAuthor(
      id: userId.trim().isEmpty ? 'current_user' : userId,
      displayName: displayName,
      accountHandle: handle,
      avatarText: avatarText,
      avatarGradientColorValues: const <int>[0xFF6366F1, 0xFF8B5CF6],
      badge: DiscussionAuthorBadge(
        label: fallbackBadgeLabel,
        backgroundColorValue: 0xFFDBEAFE,
        foregroundColorValue: 0xFF2563EB,
      ),
    );
  }

  String _maskUserName(String username, String fallbackName) {
    if (username.trim().isEmpty) {
      return fallbackName;
    }
    final first = _firstVisibleCharacter(username);
    return '$first**';
  }

  String _maskAccount(String account) {
    final value = account.trim();
    if (value.isEmpty) {
      return '';
    }
    if (!value.contains('@')) {
      return value.length <= 3 ? '$value***' : '${value.substring(0, 3)}***';
    }
    final parts = value.split('@');
    if (parts.isEmpty) {
      return value;
    }
    final head = parts.first;
    final visible = head.length <= 3 ? head : head.substring(0, 3);
    return '$visible***@';
  }

  String _shortenToHandle(String displayName) {
    final value = displayName.trim();
    if (value.isEmpty) {
      return 'usr***';
    }
    final first = _firstVisibleCharacter(value);
    return '$first***';
  }

  String _firstVisibleCharacter(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '投';
    }
    return String.fromCharCode(trimmed.runes.first);
  }
}
