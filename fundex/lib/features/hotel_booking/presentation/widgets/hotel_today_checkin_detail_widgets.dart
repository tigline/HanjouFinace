import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelTodayCheckInDetailContent extends StatelessWidget {
  const HotelTodayCheckInDetailContent({
    super.key,
    required this.detail,
    required this.onCheckIn,
  });

  final HotelOrderDetail detail;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final entries = _entries(detail);
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          sliver: SliverList.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _CheckInRoomDetailCard(
                detail: detail,
                entry: entries[index],
                index: index,
                total: entries.length,
                onCheckIn: onCheckIn,
              );
            },
          ),
        ),
      ],
    );
  }

  List<_CheckInRoomEntry> _entries(HotelOrderDetail detail) {
    final entries = <_CheckInRoomEntry>[];
    for (final room in detail.rooms) {
      if (room.guests.isEmpty) {
        entries.add(_CheckInRoomEntry(room: room));
        continue;
      }
      for (final guest in room.guests) {
        entries.add(_CheckInRoomEntry(room: room, guest: guest));
      }
    }
    if (entries.isNotEmpty) {
      return entries;
    }
    return <_CheckInRoomEntry>[const _CheckInRoomEntry()];
  }
}

class _CheckInRoomEntry {
  const _CheckInRoomEntry({this.room, this.guest});

  final HotelOrderRoomSummary? room;
  final HotelOrderRoomGuest? guest;
}

class _CheckInRoomDetailCard extends StatelessWidget {
  const _CheckInRoomDetailCard({
    required this.detail,
    required this.entry,
    required this.index,
    required this.total,
    required this.onCheckIn,
  });

  final HotelOrderDetail detail;
  final _CheckInRoomEntry entry;
  final int index;
  final int total;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final summary = detail.summary;
    final title = summary.hotelName.isNotEmpty
        ? summary.hotelName
        : summary.buildingName;
    final address = detail.address.isNotEmpty
        ? detail.address
        : summary.hotelAddress;
    final imageUrl = _firstNotEmpty(<String>[
      entry.room?.imageUrl ?? '',
      detail.imageUrl,
      summary.hotelImageUrl,
    ]);
    final guest = entry.guest;
    final room = entry.room;
    final roomType = _firstNotEmpty(<String>[
      guest?.roomTypeName ?? '',
      room?.name ?? '',
    ]);
    final guestName = _firstNotEmpty(<String>[
      guest?.name ?? '',
      detail.guestName,
      summary.hotelName,
    ]);
    final guestCount = guest?.guestCount ?? detail.adultCount ?? 1;
    final checkInStatus = _firstNotEmpty(<String>[
      guest?.checkedInText ?? '',
      detail.checkedInText,
      context.l10n.hotelTodayCheckInWaiting,
    ]);
    final password = _firstNotEmpty(<String>[
      guest?.password ?? '',
      detail.gatePassword,
    ]);

    return Material(
      color: colors.brandWhite,
      elevation: 2,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(UiTokens.radius20),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _RoomCountBadge(text: '${index + 1}/$total'),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        title.isEmpty
                            ? context.l10n.hotelUnnamedProperty
                            : title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (address.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: colors.textPrimary,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                address,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(UiTokens.radius12),
              child: AspectRatio(
                aspectRatio: 2.25,
                child: AppRemoteImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(iconSize: 40),
                  errorWidget: const HotelDetailImagePlaceholder(iconSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInTimeLabel,
              value: _formatDateTime(summary.checkIn),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckOutTimeLabel,
              value: _formatDateTime(summary.checkOut),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInRoomTypeLabel,
              value: roomType,
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInGuestLabel,
              value: guestName,
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInGuestCountLabel,
              value: guestCount.toString(),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInStatusLabel,
              value: checkInStatus,
            ),
            _WifiInfoRow(password: password),
            const SizedBox(height: 18),
            _CheckInSubmitButton(
              label: context.l10n.hotelTodayCheckInAction,
              onPressed: onCheckIn,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '--';
    }
    final parsed = DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
    if (parsed == null) {
      return trimmed;
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsed);
  }

  String _firstNotEmpty(List<String> values) {
    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return '';
  }
}

class _RoomCountBadge extends StatelessWidget {
  const _RoomCountBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              value.trim().isEmpty ? '--' : value.trim(),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WifiInfoRow extends StatelessWidget {
  const _WifiInfoRow({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final hasPassword = password.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              context.l10n.hotelTodayCheckInWifiLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              hasPassword
                  ? context.l10n.hotelTodayCheckInWifiPassword(password.trim())
                  : '--',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckInSubmitButton extends StatelessWidget {
  const _CheckInSubmitButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.brandPrimary,
          foregroundColor: colors.onDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.onDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
