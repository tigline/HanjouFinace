import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../state/notifications_state.dart';

class NotificationsTabBar extends StatelessWidget {
  const NotificationsTabBar({
    super.key,
    required this.selectedTab,
    required this.importantLabel,
    required this.generalLabel,
    required this.onTabSelected,
  });

  final NotificationsTab selectedTab;
  final String importantLabel;
  final String generalLabel;
  final ValueChanged<NotificationsTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColorTokens.fundexBorder)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _NotificationsTabItem(
              label: importantLabel,
              isActive: selectedTab == NotificationsTab.important,
              onTap: () => onTabSelected(NotificationsTab.important),
            ),
          ),
          Expanded(
            child: _NotificationsTabItem(
              label: generalLabel,
              isActive: selectedTab == NotificationsTab.general,
              onTap: () => onTabSelected(NotificationsTab.general),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsTabItem extends StatelessWidget {
  const _NotificationsTabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
      color: isActive
          ? AppColorTokens.fundexDanger
          : AppColorTokens.fundexTextTertiary,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Text(label, style: labelStyle),
              if (isActive)
                const Positioned(
                  left: 40,
                  right: 40,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColorTokens.fundexDanger,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: SizedBox(height: 3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
