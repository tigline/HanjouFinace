import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';
import '../../support/member_profile_option_item.dart';

class MemberProfileSuitabilityStepPage extends StatelessWidget {
  const MemberProfileSuitabilityStepPage({
    super.key,
    required this.occupation,
    required this.annualIncome,
    required this.financialAssets,
    required this.investmentPurpose,
    required this.fundSource,
    required this.riskTolerance,
    required this.occupationItems,
    required this.annualIncomeItems,
    required this.financialAssetItems,
    required this.investmentPurposeItems,
    required this.fundSourceItems,
    required this.riskToleranceItems,
    required this.investmentExperienceOptions,
    required this.selectedExperiences,
    required this.showFundSourceWarning,
    required this.fundSourceWarningBody,
    this.primaryButtonEnabled = true,
    this.onOccupationChanged,
    this.onAnnualIncomeChanged,
    this.onFinancialAssetsChanged,
    this.onInvestmentPurposeChanged,
    this.onFundSourceChanged,
    this.onRiskToleranceChanged,
    this.onToggleExperience,
    this.onNext,
  });

  final String? occupation;
  final String? annualIncome;
  final String? financialAssets;
  final String? investmentPurpose;
  final String? fundSource;
  final String? riskTolerance;
  final List<DropdownMenuItem<String>> occupationItems;
  final List<DropdownMenuItem<String>> annualIncomeItems;
  final List<DropdownMenuItem<String>> financialAssetItems;
  final List<DropdownMenuItem<String>> investmentPurposeItems;
  final List<DropdownMenuItem<String>> fundSourceItems;
  final List<DropdownMenuItem<String>> riskToleranceItems;
  final List<MemberProfileOptionItem> investmentExperienceOptions;
  final Set<String> selectedExperiences;
  final bool showFundSourceWarning;
  final String fundSourceWarningBody;
  final bool primaryButtonEnabled;
  final ValueChanged<String?>? onOccupationChanged;
  final ValueChanged<String?>? onAnnualIncomeChanged;
  final ValueChanged<String?>? onFinancialAssetsChanged;
  final ValueChanged<String?>? onInvestmentPurposeChanged;
  final ValueChanged<String?>? onFundSourceChanged;
  final ValueChanged<String?>? onRiskToleranceChanged;
  final ValueChanged<String>? onToggleExperience;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep3Title,
      description: l10n.memberProfileStep3Description,
      primaryButtonLabel: l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MemberProfileSelectField<String>(
            label: l10n.memberProfileOccupationLabel,
            value: occupation,
            items: occupationItems,
            onChanged: onOccupationChanged,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: MemberProfileSelectField<String>(
                  label: l10n.memberProfileAnnualIncomeLabel,
                  value: annualIncome,
                  items: annualIncomeItems,
                  onChanged: onAnnualIncomeChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MemberProfileSelectField<String>(
                  label: l10n.memberProfileFinancialAssetsLabel,
                  value: financialAssets,
                  items: financialAssetItems,
                  onChanged: onFinancialAssetsChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.memberProfileInvestmentExperienceLabel,
            style: (Theme.of(context).textTheme.labelLarge ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: investmentExperienceOptions
                .map((MemberProfileOptionItem option) {
                  return MemberProfileChoiceChip(
                    label: option.label,
                    selected: selectedExperiences.contains(option.value),
                    onTap: () => onToggleExperience?.call(option.value),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 14),
          MemberProfileSelectField<String>(
            label: l10n.memberProfileInvestmentPurposeLabel,
            value: investmentPurpose,
            items: investmentPurposeItems,
            onChanged: onInvestmentPurposeChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileSelectField<String>(
            label: l10n.memberProfileFundSourceLabel,
            value: fundSource,
            items: fundSourceItems,
            onChanged: onFundSourceChanged,
          ),
          if (showFundSourceWarning) ...<Widget>[
            const SizedBox(height: 12),
            MemberProfileNoticeCard(
              icon: const Text('⚠️', style: TextStyle(fontSize: 18)),
              title: l10n.memberProfileFundSourceWarningTitle,
              body: fundSourceWarningBody,
              backgroundColor: const Color(0xFFFFF1F2),
              borderColor: const Color(0xFFFCA5A5),
              foregroundColor: const Color(0xFFB91C1C),
            ),
          ],
          const SizedBox(height: 14),
          MemberProfileSelectField<String>(
            label: l10n.memberProfileRiskToleranceLabel,
            value: riskTolerance,
            items: riskToleranceItems,
            onChanged: onRiskToleranceChanged,
          ),
        ],
      ),
    );
  }
}
