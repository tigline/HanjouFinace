import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_member_contact_form_page.dart';
import '../widgets/hotel_state_views.dart';

class HotelMemberContactsPage extends ConsumerWidget {
  const HotelMemberContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final contactsState = ref.watch(hotelMemberContactsProvider);
    final contacts = contactsState.valueOrNull ?? const <HotelMemberContact>[];
    return Scaffold(
      backgroundColor: colors.surfaceAlt,
      appBar: AppNavigationBar(
        title: context.l10n.hotelMemberContactsTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/hotel-booking');
          },
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(hotelMemberContactsProvider.future),
        child: contactsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverFillRemaining(
                hasScrollBody: false,
                child: HotelFullPageError(
                  onRetry: () => ref.invalidate(hotelMemberContactsProvider),
                ),
              ),
            ],
          ),
          data: (contacts) {
            if (contacts.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyContactsView(
                      onAdd: () => _openContactForm(context, ref),
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _HotelMemberContactCard(
                  contact: contact,
                  onTap: () => _openContactForm(context, ref, contact: contact),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: contacts.length,
            );
          },
        ),
      ),
      bottomNavigationBar: contacts.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PrimaryCtaButton(
                label: context.l10n.hotelMemberContactsAddAction,
                onPressed: () => _openContactForm(context, ref),
                borderRadius: BorderRadius.circular(999),
                backgroundColor: colors.primary,
                shadowColor: colors.primary.withValues(alpha: 0.22),
              ),
            ),
    );
  }

  Future<void> _openContactForm(
    BuildContext context,
    WidgetRef ref, {
    HotelMemberContact? contact,
  }) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => HotelMemberContactFormPage(contact: contact),
        fullscreenDialog: true,
      ),
    );
    if (saved == true) {
      ref.invalidate(hotelMemberContactsProvider);
    }
  }
}

class _EmptyContactsView extends StatelessWidget {
  const _EmptyContactsView({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            context.l10n.hotelMemberContactsEmpty,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: Text(context.l10n.hotelMemberContactsAddAction),
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              textStyle: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelMemberContactCard extends StatelessWidget {
  const _HotelMemberContactCard({required this.contact, required this.onTap});

  final HotelMemberContact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final name = contact.displayName.isEmpty ? '-' : contact.displayName;
    final country = contact.nationalityText.isNotEmpty
        ? contact.nationalityText
        : contact.nationality;
    final phone = _phoneText(contact);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.7)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: colors.surface.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UiTokens.radius12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    if (contact.isDefault) ...<Widget>[
                      const SizedBox(width: 10),
                      _DefaultBadge(),
                    ],
                    const Spacer(),
                    Icon(
                      Icons.edit_outlined,
                      color: colors.textTertiary,
                      size: 20,
                    ),
                    
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    _InlineInfo(
                      icon: Icons.public_outlined,
                      value: country.isEmpty ? '-' : country,
                    ),

                    const SizedBox(width: 14),
                    _InlineInfo(icon: Icons.call_outlined, value: phone),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoLine(
                  icon: Icons.mail_outline_rounded,
                  value: contact.email.isEmpty ? '-' : contact.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          context.l10n.hotelMemberContactsDefault,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.brandSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: colors.textTertiary, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Icon(icon, color: colors.textTertiary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
