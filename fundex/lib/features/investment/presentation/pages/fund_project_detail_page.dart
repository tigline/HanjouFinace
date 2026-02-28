import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_detail_static_content.dart';

class FundProjectDetailPage extends ConsumerWidget {
  const FundProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(fundProjectDetailProvider(projectId));

    return detailAsync.when(
      loading: () => const _DetailScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (Object error, StackTrace stackTrace) => _DetailScaffold(
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
          fundDetailStaticContentProvider(locale.languageCode),
        );
        final staticContent = staticContentAsync.asData?.value;
        final currencyFormatter = NumberFormat.currency(
          locale: locale.toLanguageTag(),
          symbol: '¥',
          decimalDigits: 0,
        );
        final infoItems = _buildPrimaryInfoItems(
          context,
          project,
          currencyFormatter,
        );
        final propertyItems = _buildPropertyInfoItems(context, project);
        final contractItems = _buildContractItems(
          context,
          project,
          currencyFormatter,
        );
        final operatorItems = _buildOperatorItems(context, project);
        final operatorMetaText = _buildOperatorMetaText(project);
        final documentItems = _buildDocumentItems(context, project);
        final structureData = _buildProtectionStructure(context, project);

        return _DetailScaffold(
          actionBar: FundDetailStickyActionBar(
            label: _resolveActionLabel(context, project),
            enabled: _isActionEnabled(project),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.fundDetailApplyComingSoonToast),
                ),
              );
            },
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              FundDetailHeroHeader(
                gradientColors: _resolveHeroGradientColors(
                  project.projectStatus,
                ),
                badges: _buildHeroBadges(context, project),
                onBackTap: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/funds');
                },
                onFavoriteTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      project.projectName,
                      style:
                          (Theme.of(context).textTheme.headlineSmall ??
                                  const TextStyle())
                              .copyWith(
                                color: AppColorTokens.fundexText,
                                fontWeight: FontWeight.w900,
                                height: 1.25,
                              ),
                    ),
                    const SizedBox(height: UiTokens.spacing12),
                    _YieldHighlightCard(
                      label: context.l10n.fundDetailEstimatedYieldAnnualLabel,
                      value: _formatYieldPercent(_resolveYieldRatio(project)),
                      disclaimer: context.l10n.fundDetailYieldDisclaimer,
                    ),
                  ],
                ),
              ),
              if (infoItems.isNotEmpty) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailKeyFactsTitle,
                  child: FundDetailInfoGrid(items: infoItems),
                ),
              ],
              if (structureData != null) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailPreferredStructureTitle,
                  child: _ProtectionStructureCard(data: structureData),
                ),
              ],
              if (propertyItems.isNotEmpty) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailPropertyInfoTitle,
                  child: FundDetailInfoGrid(items: propertyItems),
                ),
              ],
              if (staticContent != null) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
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
                                    color: AppColorTokens.fundexTextTertiary,
                                    height: 1.6,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (contractItems.isNotEmpty ||
                  staticContent != null) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailContractOverviewTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (contractItems.isNotEmpty)
                        FundDetailInfoGrid(items: contractItems),
                      if (staticContent != null) ...<Widget>[
                        if (contractItems.isNotEmpty)
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
                              title: staticContent.legalSections[index].title,
                              rows: staticContent.legalSections[index].rows
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
                              title: staticContent.legalSections[index].title,
                              body:
                                  staticContent.legalSections[index].body ?? '',
                            ),
                          if (index < staticContent.legalSections.length - 1)
                            const SizedBox(height: UiTokens.spacing8),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
              if (operatorItems.isNotEmpty ||
                  operatorMetaText != null) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailOperatorInfoTitle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (operatorItems.isNotEmpty)
                        FundDetailInfoGrid(items: operatorItems),
                      if (operatorMetaText != null) ...<Widget>[
                        if (operatorItems.isNotEmpty)
                          const SizedBox(height: UiTokens.spacing8),
                        Text(
                          operatorMetaText,
                          style:
                              (Theme.of(context).textTheme.labelSmall ??
                                      const TextStyle())
                                  .copyWith(
                                    color: AppColorTokens.fundexTextSecondary,
                                    height: 1.6,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (documentItems.isNotEmpty) ...<Widget>[
                const SizedBox(height: UiTokens.spacing16),
                FundDetailSection(
                  title: context.l10n.fundDetailDocumentsTitle,
                  child: FundDetailDocumentList(items: documentItems),
                ),
              ],
              const SizedBox(height: UiTokens.spacing16),
              FundDetailSection(
                title: context.l10n.fundDetailCommentsTitle,
                child: const _CommentsPlaceholderCard(),
              ),
              const SizedBox(height: 104),
            ],
          ),
        );
      },
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.body, this.actionBar});

  final Widget body;
  final Widget? actionBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.fundexBackground,
      body: body,
      bottomNavigationBar: actionBar,
    );
  }
}

class _YieldHighlightCard extends StatelessWidget {
  const _YieldHighlightCard({
    required this.label,
    required this.value,
    required this.disclaimer,
  });

  final String label;
  final String value;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style:
                (Theme.of(context).textTheme.labelMedium ?? const TextStyle())
                    .copyWith(color: AppColorTokens.fundexTextSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style:
                (Theme.of(context).textTheme.displaySmall ?? const TextStyle())
                    .copyWith(
                      color: AppColorTokens.fundexDanger,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
          ),
          const SizedBox(height: 6),
          Text(
            disclaimer,
            style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                .copyWith(color: AppColorTokens.fundexTextTertiary),
          ),
        ],
      ),
    );
  }
}

class _ProtectionStructureData {
  const _ProtectionStructureData({
    required this.primaryLabel,
    required this.primaryRatio,
    required this.secondaryLabel,
    required this.secondaryRatio,
  });

  final String primaryLabel;
  final double primaryRatio;
  final String secondaryLabel;
  final double secondaryRatio;
}

class _ProtectionStructureCard extends StatelessWidget {
  const _ProtectionStructureCard({required this.data});

  final _ProtectionStructureData data;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 24,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: (data.primaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColorTokens.fundexAccent,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.primaryLabel} ${(data.primaryRatio * 100).round()}%',
                        style:
                            (Theme.of(context).textTheme.labelSmall ??
                                    const TextStyle())
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (data.secondaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColorTokens.fundexWarning,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.secondaryLabel} ${(data.secondaryRatio * 100).round()}%',
                        style:
                            (Theme.of(context).textTheme.labelSmall ??
                                    const TextStyle())
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.primaryLabel,
                  style:
                      (Theme.of(context).textTheme.labelSmall ??
                              const TextStyle())
                          .copyWith(color: AppColorTokens.fundexTextSecondary),
                ),
              ),
              Text(
                data.secondaryLabel,
                style:
                    (Theme.of(context).textTheme.labelSmall ??
                            const TextStyle())
                        .copyWith(color: AppColorTokens.fundexTextSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentsPlaceholderCard extends StatelessWidget {
  const _CommentsPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Text(
        context.l10n.fundDetailCommentsPlaceholder,
        style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
            .copyWith(color: AppColorTokens.fundexTextSecondary, height: 1.7),
      ),
    );
  }
}

List<FundDetailInfoItemData> _buildPrimaryInfoItems(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final items = <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundListPeriodLabel,
      value: _resolvePeriodText(context, project),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailFundTotalLabel,
      value: _formatCurrency(project.amountApplication, currencyFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailMinimumInvestmentLabel,
      value: _resolveMinimumInvestmentText(context, project, currencyFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundListMethodLabel,
      value: _resolveMethodLabel(context, project.offeringMethod),
    ),
  ];

  final dividendText = _resolveDividendText(context, project);
  if (dividendText != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailDividendLabel,
        value: dividendText,
      ),
    );
  }

  final lotteryDateText = _resolveLotteryDateText(context, project);
  if (lotteryDateText != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailLotteryDateLabel,
        value: lotteryDateText,
      ),
    );
  }

  return items;
}

List<FundDetailInfoItemData> _buildPropertyInfoItems(
  BuildContext context,
  FundProject project,
) {
  final items = <FundDetailInfoItemData>[];
  final location = _resolveLocationText(project);
  if (location != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailLocationLabel,
        value: location,
      ),
    );
  }

  final propertyType = _detailString(project.detailData, const <String>[
    'propertyType',
    'targetPropertyType',
    'realEstateType',
  ]);
  if (propertyType != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailPropertyTypeLabel,
        value: propertyType,
      ),
    );
  }

  final structure = _detailString(project.detailData, const <String>[
    'structure',
    'buildingStructure',
  ]);
  if (structure != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailStructureLabel,
        value: structure,
      ),
    );
  }

  final builtYear = _detailString(project.detailData, const <String>[
    'builtYear',
    'builtAt',
    'completionYear',
  ]);
  if (builtYear != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailBuiltYearLabel,
        value: builtYear,
      ),
    );
  }

  return items;
}

List<FundDetailInfoItemData> _buildContractItems(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final items = <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailContractTypeLabel,
      value:
          _detailString(project.detailData, const <String>[
            'contractType',
            'schemeType',
          ]) ??
          context.l10n.fundDetailContractTypeValue,
    ),
  ];

  final targetPropertyType = _detailString(project.detailData, const <String>[
    'targetPropertyType',
    'propertyType',
    'realEstateType',
  ]);
  if (targetPropertyType != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailTargetPropertyTypeLabel,
        value: targetPropertyType,
      ),
    );
  }

  final appraisalValue = _detailInt(project.detailData, const <String>[
    'appraisalValue',
    'propertyAppraisalValue',
  ]);
  if (appraisalValue != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailAppraisalValueLabel,
        value: _formatCurrency(appraisalValue, currencyFormatter),
      ),
    );
  }

  final acquisitionPrice = _detailInt(project.detailData, const <String>[
    'acquisitionPrice',
    'plannedAcquisitionPrice',
  ]);
  if (acquisitionPrice != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailAcquisitionPriceLabel,
        value: _formatCurrency(acquisitionPrice, currencyFormatter),
      ),
    );
  }

  final offerPeriod = _resolveDateRangeText(
    context,
    project.offeringStartDatetime,
    project.offeringEndDatetime,
  );
  if (offerPeriod != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailOfferPeriodLabel,
        value: offerPeriod,
      ),
    );
  }

  final operationStart = _resolveDateText(context, project.scheduledStartDate);
  if (operationStart != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailOperationStartLabel,
        value: operationStart,
      ),
    );
  }

  final operationEnd = _resolveDateText(context, project.scheduledEndDate);
  if (operationEnd != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailOperationEndLabel,
        value: operationEnd,
      ),
    );
  }

  return items;
}

List<FundDetailInfoItemData> _buildOperatorItems(
  BuildContext context,
  FundProject project,
) {
  final items = <FundDetailInfoItemData>[];
  final companyName = project.operatingCompany?.trim();
  if (companyName != null && companyName.isNotEmpty) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailOperatorCompanyLabel,
        value: companyName,
      ),
    );
  }

  final permitNumber = _detailString(project.detailData, const <String>[
    'permitNumber',
    'licenseNumber',
    'registrationNumber',
  ]);
  if (permitNumber != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailPermitNumberLabel,
        value: permitNumber,
      ),
    );
  }

  final representative = _detailString(project.detailData, const <String>[
    'representative',
    'representativeName',
    'ceoName',
  ]);
  if (representative != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailRepresentativeLabel,
        value: representative,
      ),
    );
  }

  final companyAddress = _detailString(project.detailData, const <String>[
    'companyAddress',
    'operatorAddress',
    'companyLocation',
  ]);
  if (companyAddress != null) {
    items.add(
      FundDetailInfoItemData(
        label: context.l10n.fundDetailCompanyAddressLabel,
        value: companyAddress,
      ),
    );
  }

  return items;
}

String? _buildOperatorMetaText(FundProject project) {
  final fragments = <String>[];
  final capital = _detailString(project.detailData, const <String>[
    'capital',
    'capitalAmount',
  ]);
  if (capital != null) {
    fragments.add(capital);
  }
  final established = _detailString(project.detailData, const <String>[
    'establishedAt',
    'establishedDate',
  ]);
  if (established != null) {
    fragments.add(established);
  }
  final businessStart = _detailString(project.detailData, const <String>[
    'businessStartDate',
    'serviceStartDate',
  ]);
  if (businessStart != null) {
    fragments.add(businessStart);
  }

  if (fragments.isEmpty) {
    return null;
  }
  return fragments.join(' ・ ');
}

List<FundDetailDocumentItemData> _buildDocumentItems(
  BuildContext context,
  FundProject project,
) {
  return project.pdfDocuments
      .map(
        (FundProjectPdfDocument document) => FundDetailDocumentItemData(
          title: document.description ?? context.l10n.fundDetailDocumentsTitle,
          subtitle: document.urls.isEmpty
              ? context.l10n.fundDetailDocumentUnavailable
              : context.l10n.fundDetailDocumentReady,
          onTap: document.urls.isEmpty
              ? null
              : () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(document.urls.first)));
                },
        ),
      )
      .toList(growable: false);
}

_ProtectionStructureData? _buildProtectionStructure(
  BuildContext context,
  FundProject project,
) {
  final primary = _detailDouble(project.detailData, const <String>[
    'preferredRatio',
    'seniorRatio',
    'priorityInvestmentRatio',
  ]);
  final secondary = _detailDouble(project.detailData, const <String>[
    'subordinateRatio',
    'juniorRatio',
    'operatorRatio',
  ]);
  if (primary == null || secondary == null) {
    return null;
  }

  final normalizedPrimary = primary > 1 ? primary / 100 : primary;
  final normalizedSecondary = secondary > 1 ? secondary / 100 : secondary;
  final total = normalizedPrimary + normalizedSecondary;
  if (total <= 0) {
    return null;
  }

  return _ProtectionStructureData(
    primaryLabel: context.l10n.fundDetailSeniorInvestmentLabel,
    primaryRatio: normalizedPrimary / total,
    secondaryLabel: context.l10n.fundDetailJuniorInvestmentLabel,
    secondaryRatio: normalizedSecondary / total,
  );
}

List<FundDetailBadgeData> _buildHeroBadges(
  BuildContext context,
  FundProject project,
) {
  return <FundDetailBadgeData>[
    _buildStatusBadge(context, project.projectStatus),
    FundDetailBadgeData(
      label: _resolveMethodLabel(context, project.offeringMethod),
      backgroundColor: AppColorTokens.fundexPink.withValues(alpha: 0.88),
      foregroundColor: Colors.white,
    ),
  ];
}

FundDetailBadgeData _buildStatusBadge(BuildContext context, int? status) {
  switch (status) {
    case 1:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOpen,
        backgroundColor: AppColorTokens.fundexSuccess.withValues(alpha: 0.92),
        foregroundColor: Colors.white,
      );
    case 0:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusUpcoming,
        backgroundColor: AppColorTokens.fundexWarning.withValues(alpha: 0.92),
        foregroundColor: Colors.white,
      );
    case 4:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOperating,
        backgroundColor: AppColorTokens.fundexAccent.withValues(alpha: 0.92),
        foregroundColor: Colors.white,
      );
    case 5:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOperatingEnded,
        backgroundColor: AppColorTokens.fundexTextSecondary.withValues(
          alpha: 0.88,
        ),
        foregroundColor: Colors.white,
      );
    default:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusUnknown,
        backgroundColor: AppColorTokens.fundexTextTertiary.withValues(
          alpha: 0.88,
        ),
        foregroundColor: Colors.white,
      );
  }
}

List<Color> _resolveHeroGradientColors(int? status) {
  switch (status) {
    case 1:
      return const <Color>[
        Color(0xFF0F172A),
        Color(0xFF1E3A8A),
        Color(0xFF2563EB),
      ];
    case 0:
      return const <Color>[
        Color(0xFF7C2D12),
        Color(0xFFC2410C),
        Color(0xFFF97316),
      ];
    case 4:
      return const <Color>[
        Color(0xFF14532D),
        Color(0xFF166534),
        Color(0xFF22C55E),
      ];
    case 5:
      return const <Color>[
        Color(0xFF334155),
        Color(0xFF475569),
        Color(0xFF64748B),
      ];
    default:
      return const <Color>[
        Color(0xFF334155),
        Color(0xFF475569),
        Color(0xFF64748B),
      ];
  }
}

String _resolveActionLabel(BuildContext context, FundProject project) {
  switch (project.projectStatus) {
    case 1:
      return context.l10n.fundDetailApplyNowAction;
    case 0:
      return context.l10n.fundDetailOpenSoonAction;
    default:
      return context.l10n.fundDetailUnavailableAction;
  }
}

bool _isActionEnabled(FundProject project) {
  return project.projectStatus == 1 || project.projectStatus == 0;
}

String _resolveMethodLabel(BuildContext context, String? offeringMethod) {
  final l10n = context.l10n;
  final value = offeringMethod?.trim();
  if (value == null || value.isEmpty) {
    return l10n.fundListMethodLottery;
  }

  final normalized = value.toLowerCase();
  if (normalized.contains('lottery') ||
      value.contains('抽選') ||
      value.contains('抽签')) {
    return l10n.fundListMethodLottery;
  }
  return value;
}

String _resolveMinimumInvestmentText(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final amount = project.investmentUnit;
  if (amount == null) {
    return context.l10n.fundDetailUnknownValue;
  }
  return '${_formatCurrency(amount, currencyFormatter)} ${context.l10n.fundDetailOneUnitSuffix}';
}

String _resolvePeriodText(BuildContext context, FundProject project) {
  final period = project.investmentPeriod?.trim();
  if (period != null && period.isNotEmpty) {
    return period;
  }
  return context.l10n.fundDetailUnknownValue;
}

String? _resolveDividendText(BuildContext context, FundProject project) {
  if (project.distributionDate != null &&
      project.distributionDate!.trim().isNotEmpty) {
    return _resolveDateText(context, project.distributionDate);
  }

  switch (project.periodType?.trim().toUpperCase()) {
    case 'MONTH':
    case 'MONTHLY':
      return context.l10n.fundDetailMonthlyDistribution;
    case 'SEASON':
    case 'QUARTER':
    case 'QUARTERLY':
      return context.l10n.fundDetailQuarterlyDistribution;
    case 'HALF':
    case 'HALF_YEAR':
    case 'SEMI_ANNUAL':
      return context.l10n.fundDetailSemiAnnualDistribution;
    case 'YEAR':
    case 'YEARLY':
    case 'ANNUAL':
      return context.l10n.fundDetailAnnualDistribution;
  }

  return null;
}

String? _resolveLotteryDateText(BuildContext context, FundProject project) {
  if (!_resolveMethodLabel(
    context,
    project.offeringMethod,
  ).contains(context.l10n.fundListMethodLottery)) {
    return null;
  }
  return _resolveDateText(context, project.offeringEndDatetime);
}

String? _resolveLocationText(FundProject project) {
  final direct = _detailString(project.detailData, const <String>[
    'location',
    'address',
    'propertyAddress',
  ]);
  if (direct != null) {
    return direct;
  }

  final name = project.projectName.trim();
  if (name.contains(' ')) {
    return name.split(' ').first;
  }
  if (name.contains('　')) {
    return name.split('　').first;
  }
  final company = project.operatingCompany?.trim();
  if (company != null && company.isNotEmpty) {
    return company;
  }
  return null;
}

String _formatCurrency(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
}

String _formatYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

double? _resolveYieldRatio(FundProject project) {
  return project.expectedDistributionRatioMax ??
      project.expectedDistributionRatioMin ??
      project.investorTypes.firstWhereOrNull((FundProjectInvestorType item) {
        return item.earningsRadio != null && item.earningsRadio! > 0;
      })?.earningsRadio;
}

String? _resolveDateRangeText(
  BuildContext context,
  String? start,
  String? end,
) {
  final startText = _resolveDateText(context, start);
  final endText = _resolveDateText(context, end);
  if (startText == null || endText == null) {
    return null;
  }
  return '$startText - $endText';
}

String? _resolveDateText(BuildContext context, String? raw) {
  final value = _parseDateTime(raw);
  if (value == null) {
    return null;
  }
  return _formatDateForLocale(value, Localizations.localeOf(context));
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  return DateTime.tryParse(normalized);
}

String _formatDateForLocale(DateTime value, Locale locale) {
  final languageCode = locale.languageCode;
  if (languageCode == 'ja') {
    return DateFormat.yMd('ja').format(value);
  }
  if (languageCode == 'zh') {
    return DateFormat.yMd('zh').format(value);
  }
  return DateFormat.yMMMd(locale.toLanguageTag()).format(value);
}

String? _detailString(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null) {
      continue;
    }
    final normalized = value.toString().trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

int? _detailInt(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      continue;
    }
    final parsed = int.tryParse(value.toString());
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}

double? _detailDouble(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value == null) {
      continue;
    }
    final parsed = double.tryParse(value.toString());
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
