import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import 'hotel_member_contact_form_page.dart';
import 'hotel_state_views.dart';

Future<HotelMemberContact?> showHotelMemberContactPickerSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<HotelMemberContact>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).appColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const HotelMemberContactPickerSheet(),
  );
}

class HotelMemberContactPickerSheet extends ConsumerStatefulWidget {
  const HotelMemberContactPickerSheet({super.key});

  @override
  ConsumerState<HotelMemberContactPickerSheet> createState() =>
      _HotelMemberContactPickerSheetState();
}

class _HotelMemberContactPickerSheetState
    extends ConsumerState<HotelMemberContactPickerSheet> {
  String? _selectedContactId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final contactsState = ref.watch(hotelMemberContactsProvider);
    final contacts = contactsState.valueOrNull ?? const <HotelMemberContact>[];
    final selectedContact = _selectedContact(contacts);
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: _AddContactRow(onTap: _openAddForm),
            ),
            Divider(height: 1, color: colors.borderSoft),
            Flexible(
              child: contactsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => HotelInlineErrorNotice(
                  onRetry: () => ref.invalidate(hotelMemberContactsProvider),
                ),
                data: (contacts) {
                  if (contacts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
                        child: Text(
                          context.l10n.hotelMemberContactsEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return _ContactPickerRow(
                        contact: contact,
                        isSelected: _selectedContactId == null
                            ? index == 0
                            : contact.id == _selectedContactId,
                        onTap: () =>
                            setState(() => _selectedContactId = contact.id),
                        onEdit: () => _openEditForm(contact),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: contacts.length,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PrimaryCtaButton(
                label: context.l10n.commonConfirm,
                onPressed: selectedContact == null
                    ? null
                    : () => Navigator.of(context).pop(selectedContact),
                borderRadius: BorderRadius.circular(999),
                backgroundColor: colors.primary,
                shadowColor: colors.primary.withValues(alpha: 0.22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  HotelMemberContact? _selectedContact(List<HotelMemberContact> contacts) {
    if (_selectedContactId == null && contacts.isNotEmpty) {
      return contacts.first;
    }
    for (final contact in contacts) {
      if (contact.id == _selectedContactId) {
        return contact;
      }
    }
    return null;
  }

  Future<void> _openAddForm() async {
    final saved = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const HotelMemberContactFormPage(),
        fullscreenDialog: true,
      ),
    );
    if (saved == true && mounted) {
      ref.invalidate(hotelMemberContactsProvider);
    }
  }

  Future<void> _openEditForm(HotelMemberContact contact) async {
    final saved = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => HotelMemberContactFormPage(contact: contact),
        fullscreenDialog: true,
      ),
    );
    if (saved == true && mounted) {
      setState(() => _selectedContactId = contact.id);
      ref.invalidate(hotelMemberContactsProvider);
    }
  }
}

class _AddContactRow extends StatelessWidget {
  const _AddContactRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                ),
                child: SizedBox.square(
                  dimension: 44,
                  child: Icon(Icons.add_rounded, color: colors.onDark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  context.l10n.hotelMemberContactsAddAction,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textTertiary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactPickerRow extends StatelessWidget {
  const _ContactPickerRow({
    required this.contact,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
  });

  final HotelMemberContact contact;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final phoneText = _phoneText(contact);
    return Material(
      color: colors.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? colors.primary : colors.textTertiary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            _titleText(contact, phoneText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        if (contact.isDefault) ...<Widget>[
                          const SizedBox(width: 8),
                          _DefaultPill(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contact.email.trim().isEmpty ? '-' : contact.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                color: colors.textTertiary,
                tooltip: context.l10n.hotelMemberContactsEditTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleText(HotelMemberContact contact, String phoneText) {
    final name = contact.displayName.trim().isEmpty
        ? '-'
        : contact.displayName.trim();
    if (phoneText == '-') {
      return name;
    }
    return '$name $phoneText';
  }

  String _phoneText(HotelMemberContact contact) {
    final mobile = contact.mobile.trim();
    if (mobile.isEmpty) {
      return '-';
    }
    final intlCode = contact.intlCode.trim();
    if (intlCode.isEmpty) {
      return mobile;
    }
    return '+$intlCode $mobile';
  }
}

class _DefaultPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          context.l10n.hotelMemberContactsDefault,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
