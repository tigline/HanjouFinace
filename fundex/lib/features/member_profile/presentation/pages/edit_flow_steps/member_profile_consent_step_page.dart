import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileConsentStepPage extends StatelessWidget {
  const MemberProfileConsentStepPage({
    super.key,
    required this.electronicConsent,
    required this.antiSocialConsent,
    required this.privacyConsent,
    this.onElectronicConsentChanged,
    this.onAntiSocialConsentChanged,
    this.onPrivacyConsentChanged,
    this.onComplete,
  });

  final bool electronicConsent;
  final bool antiSocialConsent;
  final bool privacyConsent;
  final ValueChanged<bool>? onElectronicConsentChanged;
  final ValueChanged<bool>? onAntiSocialConsentChanged;
  final ValueChanged<bool>? onPrivacyConsentChanged;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep6Title,
      description: l10n.memberProfileStep6Description,
      primaryButtonLabel: l10n.memberProfileAgreeAndComplete,
      primaryButtonEnabled:
          electronicConsent && antiSocialConsent && privacyConsent,
      onPrimaryPressed: onComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MemberProfileInfoCard(
            icon: '📄',
            title: l10n.memberProfileElectronicDeliveryTitle,
            backgroundColor: const Color(0xFFF0F9FF),
            borderColor: const Color(0xFFBAE6FD),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.memberProfileElectronicDeliveryBody,
                  style:
                      (Theme.of(context).textTheme.bodySmall ??
                              const TextStyle())
                          .copyWith(height: 1.7),
                ),
                const SizedBox(height: 10),
                ...<String>[
                  l10n.memberProfileElectronicDeliveryItem1,
                  l10n.memberProfileElectronicDeliveryItem2,
                  l10n.memberProfileElectronicDeliveryItem3,
                  l10n.memberProfileElectronicDeliveryItem4,
                ].map<Widget>(
                  (String item) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      '• $item',
                      style:
                          (Theme.of(context).textTheme.bodySmall ??
                                  const TextStyle())
                              .copyWith(height: 1.7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.memberProfileElectronicDeliveryFootnote,
                  style:
                      (Theme.of(context).textTheme.labelSmall ??
                              const TextStyle())
                          .copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.86),
                            height: 1.6,
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MemberProfileCheckTile(
            label: l10n.memberProfileElectronicDeliveryConsent,
            value: electronicConsent,
            onChanged: onElectronicConsentChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileInfoCard(
            icon: '🛡️',
            title: l10n.memberProfileAntiSocialTitle,
            titleColor: Theme.of(context).textTheme.titleSmall?.color,
            body: Text(
              l10n.memberProfileAntiSocialBody,
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(height: 1.7),
            ),
          ),
          const SizedBox(height: 10),
          MemberProfileCheckTile(
            label: l10n.memberProfileAntiSocialConsent,
            value: antiSocialConsent,
            onChanged: onAntiSocialConsentChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileCheckTile(
            label: l10n.memberProfilePrivacyConsent,
            value: privacyConsent,
            onChanged: onPrivacyConsentChanged,
          ),
        ],
      ),
    );
  }
}
