import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_detail_static_content.dart';
import '../support/fund_project_detail_view_data.dart';
import '../widgets/fund_project_detail_comments_placeholder_card.dart';
import '../widgets/fund_project_detail_protection_structure_card.dart';
import '../widgets/fund_project_detail_scaffold.dart';
import '../widgets/fund_project_detail_title_block.dart';
import '../widgets/fund_project_detail_yield_highlight_card.dart';

class FundProjectDetailPage extends ConsumerWidget {
  const FundProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(fundProjectDetailProvider(projectId));

    return detailAsync.when(
      loading: () => const FundProjectDetailScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (Object error, StackTrace stackTrace) => FundProjectDetailScaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  context.l10n.fundListLoadError,
                  textAlign: TextAlign.center,
                  style:
                      (Theme.of(context).textTheme.bodyMedium ??
                              const TextStyle())
                          .copyWith(color: AppColorTokens.fundexTextSecondary),
                ),
                const SizedBox(height: UiTokens.spacing12),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(fundProjectDetailProvider(projectId)),
                  child: Text(context.l10n.fundListRetry),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (FundProject project) {
        final locale = Localizations.localeOf(context);
        final staticContentAsync = ref.watch(
          fundDetailStaticContentProvider(locale.toLanguageTag()),
        );
        final staticContent = staticContentAsync.asData?.value;
        final viewData = FundProjectDetailViewDataBuilder.build(
          context: context,
          project: project,
        );

        return FundProjectDetailScaffold(
          actionBar: FundDetailStickyActionBar(
            label: viewData.actionLabel,
            enabled: viewData.actionEnabled,
            onTap: () => context.push('/funds/$projectId/lottery-apply'),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              FundDetailHeroHeader(
                gradientColors: viewData.heroGradientColors,
                badges: viewData.heroBadges,
                imageUrls: project.photos,
                onBackTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/funds');
                },
                onFavoriteTap: () {},
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FundProjectDetailTitleBlock(project: project),
                          const SizedBox(height: UiTokens.spacing12),
                          FundProjectDetailYieldHighlightCard(
                            label: context
                                .l10n
                                .fundDetailEstimatedYieldAnnualLabel,
                            value: viewData.yieldDisplay,
                            disclaimer: context.l10n.fundDetailYieldDisclaimer,
                          ),
                        ],
                      ),
                    ),
                    if (viewData.infoItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: UiTokens.spacing16),
                      FundDetailSection(
                        title: context.l10n.fundDetailKeyFactsTitle,
                        child: FundDetailInfoTable(items: viewData.infoItems),
                      ),
                    ],
                    if (viewData.protectionStructure != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailPreferredStructureTitle,
                        child: FundProjectDetailProtectionStructureCard(
                          data: viewData.protectionStructure!,
                        ),
                      ),
                    ],
                    if (viewData.propertyItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailPropertyInfoTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FundPropertyMapPreviewCard(
                              addressLabel: viewData.propertyLocation,
                              onTap: () {
                                FundPropertyMapBottomSheet.show(
                                  context: context,
                                  title: viewData.propertyLocation,
                                  destination: viewData.propertyCoordinate,
                                  strings: FundPropertyMapSheetStrings(
                                    close: context.l10n.fundDetailMapClose,
                                    destination:
                                        context.l10n.fundDetailMapDestination,
                                    currentLocation: context
                                        .l10n
                                        .fundDetailMapCurrentLocation,
                                    directions:
                                        context.l10n.fundDetailMapDirections,
                                    openMapApp:
                                        context.l10n.fundDetailMapOpenMapApp,
                                    cancel: context.l10n.fundDetailMapCancel,
                                    locationPermissionDenied: context
                                        .l10n
                                        .fundDetailMapPermissionDenied,
                                    locationUnavailable:
                                        context.l10n.fundDetailMapUnavailable,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            FundDetailInfoTable(items: viewData.propertyItems),
                          ],
                        ),
                      ),
                    ],
                    if (staticContent != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: staticContent.riskSection.title,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FundDetailContentCard(
                              backgroundColor: AppColorTokens.fundexDangerLight,
                              borderColor: const Color(0xFFFECACA),
                              child: Text(
                                staticContent.riskSection.warning,
                                style:
                                    (Theme.of(context).textTheme.bodySmall ??
                                            const TextStyle())
                                        .copyWith(
                                          color: AppColorTokens.fundexDanger,
                                          fontWeight: FontWeight.w800,
                                          height: 1.6,
                                        ),
                              ),
                            ),
                            const SizedBox(height: UiTokens.spacing8),
                            FundDetailDisclosureList(
                              items: staticContent.riskSection.items
                                  .map(
                                    (FundDetailRiskItem item) =>
                                        FundDetailDisclosureItemData(
                                          title: item.title,
                                          body: item.body,
                                        ),
                                  )
                                  .toList(growable: false),
                            ),
                            if (staticContent
                                .riskSection
                                .footnotes
                                .isNotEmpty) ...<Widget>[
                              const SizedBox(height: UiTokens.spacing8),
                              Text(
                                staticContent.riskSection.footnotes.join('\n'),
                                style:
                                    (Theme.of(context).textTheme.labelSmall ??
                                            const TextStyle())
                                        .copyWith(
                                          color:
                                              AppColorTokens.fundexTextTertiary,
                                          height: 1.6,
                                        ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (viewData.contractOverviewItems.isNotEmpty ||
                        viewData.contractScheduleItems.isNotEmpty ||
                        staticContent != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailContractOverviewTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: UiTokens.spacing8,
                          children: <Widget>[
                            if (viewData.contractOverviewItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.contractOverviewItems,
                              ),
                            if (viewData.contractOverviewItems.isNotEmpty &&
                                viewData.contractScheduleItems.isNotEmpty)
                              const SizedBox(height: 1),
                            if (viewData.contractScheduleItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.contractScheduleItems,
                              ),
                            if (staticContent != null) ...<Widget>[
                              if (viewData.contractOverviewItems.isNotEmpty ||
                                  viewData.contractScheduleItems.isNotEmpty)
                                const SizedBox(height: UiTokens.spacing8),
                              for (
                                var index = 0;
                                index < staticContent.legalSections.length;
                                index++
                              ) ...<Widget>[
                                if (staticContent
                                    .legalSections[index]
                                    .rows
                                    .isNotEmpty)
                                  FundDetailKeyValueCard(
                                    title: staticContent
                                        .legalSections[index]
                                        .title,
                                    rows: staticContent
                                        .legalSections[index]
                                        .rows
                                        .map(
                                          (FundDetailLegalRow row) =>
                                              FundDetailKeyValueRowData(
                                                label: row.label,
                                                value: row.value,
                                              ),
                                        )
                                        .toList(growable: false),
                                  )
                                else
                                  FundDetailTextCard(
                                    title: staticContent
                                        .legalSections[index]
                                        .title,
                                    body:
                                        staticContent
                                            .legalSections[index]
                                            .body ??
                                        '',
                                  ),
                                if (index <
                                    staticContent.legalSections.length - 1)
                                  const SizedBox(height: UiTokens.spacing8),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (viewData.operatorItems.isNotEmpty ||
                        viewData.operatorMetaText != null) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailOperatorInfoTitle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (viewData.operatorItems.isNotEmpty)
                              FundDetailInfoTable(
                                items: viewData.operatorItems,
                              ),
                            if (viewData.operatorMetaText != null) ...<Widget>[
                              if (viewData.operatorItems.isNotEmpty)
                                const SizedBox(height: UiTokens.spacing8),
                              Text(
                                viewData.operatorMetaText!,
                                style:
                                    (Theme.of(context).textTheme.labelSmall ??
                                            const TextStyle())
                                        .copyWith(
                                          color: AppColorTokens
                                              .fundexTextSecondary,
                                          height: 1.6,
                                        ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            TextButton.icon(
                              onPressed: () => AppNotice.show(
                                context,
                                message:
                                    context.l10n.fundDetailFinancialStatusToast,
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -2,
                                  vertical: -2,
                                ),
                              ),
                              icon: const Icon(
                                Icons.show_chart_rounded,
                                size: 16,
                              ),
                              label: Text(
                                context.l10n.fundDetailFinancialStatusAction,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (viewData.documentItems.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      FundDetailSection(
                        title: context.l10n.fundDetailDocumentsTitle,
                        child: FundDetailDocumentList(
                          items: viewData.documentItems,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    FundDetailSection(
                      title: context.l10n.fundDetailCommentsTitle,
                      child: const FundProjectDetailCommentsPlaceholderCard(),
                    ),
                    const SizedBox(height: 86),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
