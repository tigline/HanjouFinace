import '../support/notification_item_view_data.dart';

enum NotificationsTab { important, general }

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.isRefreshing,
    required this.isMarkingAllRead,
    required this.selectedTab,
    required this.newsPushEnabled,
    required this.items,
    required this.unreadCount,
    required this.updatingNoticeKeys,
    this.errorMessage,
  });

  const NotificationsState.initial()
    : isLoading = true,
      isRefreshing = false,
      isMarkingAllRead = false,
      selectedTab = NotificationsTab.important,
      newsPushEnabled = false,
      items = const <NotificationItemViewData>[],
      unreadCount = 0,
      updatingNoticeKeys = const <String>{},
      errorMessage = null;

  final bool isLoading;
  final bool isRefreshing;
  final bool isMarkingAllRead;
  final NotificationsTab selectedTab;
  final bool newsPushEnabled;
  final List<NotificationItemViewData> items;
  final int unreadCount;
  final Set<String> updatingNoticeKeys;
  final String? errorMessage;

  List<NotificationItemViewData> get importantItems {
    return items
        .where((NotificationItemViewData item) => item.isImportant)
        .toList(growable: false);
  }

  List<NotificationItemViewData> get generalItems {
    return items
        .where((NotificationItemViewData item) => !item.isImportant)
        .toList(growable: false);
  }

  List<NotificationItemViewData> itemsForTab(NotificationsTab tab) {
    return tab == NotificationsTab.important ? importantItems : generalItems;
  }

  bool get hasData => items.isNotEmpty;

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isMarkingAllRead,
    NotificationsTab? selectedTab,
    bool? newsPushEnabled,
    List<NotificationItemViewData>? items,
    int? unreadCount,
    Set<String>? updatingNoticeKeys,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      selectedTab: selectedTab ?? this.selectedTab,
      newsPushEnabled: newsPushEnabled ?? this.newsPushEnabled,
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      updatingNoticeKeys: updatingNoticeKeys ?? this.updatingNoticeKeys,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
