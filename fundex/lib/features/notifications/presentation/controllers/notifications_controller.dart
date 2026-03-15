import 'dart:async';

import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/notifications_remote_data_source.dart';
import '../state/notifications_state.dart';
import '../support/notification_item_view_data.dart';

class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this._remoteDataSource, this._storage)
    : super(const NotificationsState.initial()) {
    unawaited(_bootstrap());
  }

  static const String _newsPushStorageKey = 'notifications_news_push_enabled';
  static const int _defaultLimit = 100;

  final NotificationsRemoteDataSource _remoteDataSource;
  final KeyValueStorage _storage;

  Future<void> _bootstrap() async {
    await _restoreNewsPushEnabled();
    await loadNotices();
  }

  Future<void> _restoreNewsPushEnabled() async {
    final stored = await _storage.read(_newsPushStorageKey);
    if (!mounted) {
      return;
    }
    state = state.copyWith(newsPushEnabled: stored == '1');
  }

  Future<void> setNewsPushEnabled(bool enabled) async {
    state = state.copyWith(newsPushEnabled: enabled);
    await _storage.write(_newsPushStorageKey, enabled ? '1' : '0');
  }

  void selectTab(NotificationsTab tab) {
    if (state.selectedTab == tab) {
      return;
    }
    state = state.copyWith(selectedTab: tab);
  }

  Future<void> clearForGuestMode() async {
    if (!mounted) {
      return;
    }
    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      isMarkingAllRead: false,
      items: const <NotificationItemViewData>[],
      unreadCount: 0,
      updatingNoticeKeys: const <String>{},
      clearError: true,
    );
  }

  Future<void> loadNotices({bool refresh = false}) async {
    if (state.isLoading && !refresh) {
      return;
    }
    if (state.isRefreshing && refresh) {
      return;
    }

    state = state.copyWith(
      isLoading: !refresh,
      isRefreshing: refresh,
      clearError: true,
    );

    try {
      final noticesFuture = _remoteDataSource.fetchNotices(
        startPage: 1,
        limit: _defaultLimit,
      );
      final statisticsFuture = _remoteDataSource.fetchStatistics();

      final notices = await noticesFuture;
      final statistics = await statisticsFuture;

      final mapped = notices
          .map(NotificationItemViewData.fromNoticeDto)
          .toList(growable: false);
      final sorted = _sortByCreatedAtDesc(mapped);
      final fallbackUnread = sorted
          .where((NotificationItemViewData item) => !item.isRead)
          .length;

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        items: sorted,
        unreadCount: statistics.uncheck ?? fallbackUnread,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'notifications_load_failed',
      );
    }
  }

  Future<void> refreshNotices() {
    return loadNotices(refresh: true);
  }

  Future<int> markAllAsReadCurrentTab() {
    return markAllAsRead(state.selectedTab);
  }

  Future<int> markAllAsRead(NotificationsTab tab) async {
    if (state.isMarkingAllRead) {
      return 0;
    }

    final targets = state
        .itemsForTab(tab)
        .where(
          (NotificationItemViewData item) => !item.isRead && item.id != null,
        )
        .toList(growable: false);
    if (targets.isEmpty) {
      return 0;
    }

    var updatedCount = 0;
    var hasError = false;
    state = state.copyWith(isMarkingAllRead: true, clearError: true);

    for (final item in targets) {
      final itemId = item.id;
      if (itemId == null) {
        continue;
      }
      try {
        final checked = await _remoteDataSource.checkNotice(id: itemId);
        final updated = NotificationItemViewData.fromNoticeDto(checked);
        _replaceItem(
          updated.copyWith(
            isRead: true,
            title: updated.title.isNotEmpty ? updated.title : item.title,
            body: updated.body.isNotEmpty ? updated.body : item.body,
            dateLabel: updated.dateLabel.isNotEmpty
                ? updated.dateLabel
                : item.dateLabel,
            createdAt: updated.createdAt ?? item.createdAt,
            isImportant: updated.isImportant || item.isImportant,
          ),
        );
        updatedCount += 1;
      } catch (_) {
        hasError = true;
      }
    }

    if (!mounted) {
      return updatedCount;
    }

    state = state.copyWith(
      isMarkingAllRead: false,
      unreadCount: _calculateUnreadCount(state.items),
      errorMessage: hasError && updatedCount == 0
          ? 'notifications_mark_all_failed'
          : null,
      clearError: !(hasError && updatedCount == 0),
    );
    return updatedCount;
  }

  Future<NotificationItemViewData?> openNotice(
    NotificationItemViewData item,
  ) async {
    final itemId = item.id;
    if (itemId == null) {
      return item;
    }

    if (item.isRead) {
      return item;
    }

    if (state.updatingNoticeKeys.contains(item.key)) {
      return item;
    }

    final nextUpdating = Set<String>.from(state.updatingNoticeKeys)
      ..add(item.key);
    state = state.copyWith(updatingNoticeKeys: nextUpdating, clearError: true);

    try {
      final checked = await _remoteDataSource.checkNotice(id: itemId);
      final refreshed = NotificationItemViewData.fromNoticeDto(checked);
      final updated = refreshed.copyWith(
        isRead: true,
        title: refreshed.title.isNotEmpty ? refreshed.title : item.title,
        body: refreshed.body.isNotEmpty ? refreshed.body : item.body,
        dateLabel: refreshed.dateLabel.isNotEmpty
            ? refreshed.dateLabel
            : item.dateLabel,
        createdAt: refreshed.createdAt ?? item.createdAt,
        isImportant: refreshed.isImportant || item.isImportant,
      );

      final merged = _replaceItem(updated);
      state = state.copyWith(
        updatingNoticeKeys: Set<String>.from(state.updatingNoticeKeys)
          ..remove(item.key),
        unreadCount: _calculateUnreadCount(merged),
        clearError: true,
      );
      return merged.firstWhere(
        (NotificationItemViewData current) =>
            (updated.id != null && current.id == updated.id) ||
            current.key == updated.key,
        orElse: () => updated,
      );
    } catch (_) {
      final nextKeys = Set<String>.from(state.updatingNoticeKeys)
        ..remove(item.key);
      state = state.copyWith(
        updatingNoticeKeys: nextKeys,
        errorMessage: 'notifications_check_failed',
      );
      return item;
    }
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(clearError: true);
  }

  List<NotificationItemViewData> _replaceItem(NotificationItemViewData next) {
    final updated = state.items
        .map((NotificationItemViewData current) {
          if (next.id != null && current.id == next.id) {
            return next;
          }
          if (current.key == next.key) {
            return next;
          }
          return current;
        })
        .toList(growable: false);
    final sorted = _sortByCreatedAtDesc(updated);
    state = state.copyWith(items: sorted);
    return sorted;
  }

  int _calculateUnreadCount(List<NotificationItemViewData> items) {
    return items.where((NotificationItemViewData item) => !item.isRead).length;
  }

  List<NotificationItemViewData> _sortByCreatedAtDesc(
    List<NotificationItemViewData> source,
  ) {
    final sorted = List<NotificationItemViewData>.from(source);
    sorted.sort((a, b) {
      final left = a.createdAt;
      final right = b.createdAt;
      if (left != null && right != null) {
        return right.compareTo(left);
      }
      if (right != null) {
        return 1;
      }
      if (left != null) {
        return -1;
      }
      return b.dateLabel.compareTo(a.dateLabel);
    });
    return sorted;
  }
}
