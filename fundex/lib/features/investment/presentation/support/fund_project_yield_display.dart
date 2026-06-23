import 'package:flutter/material.dart';
import 'package:fundex/app/localization/app_localizations_ext.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/fund_project.dart';

String resolveFundProjectYieldDisplay(FundProject project) {
  final openInvestorRatios = project.investorTypes
      .where((FundProjectInvestorType item) => item.isOpen == true)
      .map((FundProjectInvestorType item) => item.earningsRadio)
      .whereType<double>()
      .where((double value) => value > 0)
      .toList(growable: false);
  if (openInvestorRatios.isNotEmpty) {
    return _formatYieldRange(
      minimum: openInvestorRatios.reduce((double a, double b) => a < b ? a : b),
      maximum: openInvestorRatios.reduce((double a, double b) => a > b ? a : b),
    );
  }

  return _formatYieldRange(
    minimum: project.expectedDistributionRatioMin,
    maximum: project.expectedDistributionRatioMax,
  );
}

String resolvePeriodValue(FundProject project) {

  return (project.investmentPeriod?.trim().isNotEmpty ??
                                        false)
                                    ? project.investmentPeriod!.trim()
                                    : '--';
  
}

String resolveMinimumInvestmentText(
  BuildContext context,
  FundProject project,
  Locale locale,
) {
  final amount = project.investmentUnit;
  if (amount == null || amount <= 0) {
    return context.l10n.fundDetailUnknownValue;
  }

  final localizedAmount =
      _formatMinimumInvestmentAmountForLocale(amount, locale) ??
      NumberFormat.decimalPattern(locale.toLanguageTag()).format(amount);

  return context.l10n.fundListMinimumInvestmentValue(localizedAmount);
}

String? _formatMinimumInvestmentAmountForLocale(int amount, Locale locale) {
  if (amount < 10000 || amount % 10000 != 0) {
    return null;
  }

  final manCount = amount ~/ 10000;
  final manText = NumberFormat.decimalPattern(
    locale.toLanguageTag(),
  ).format(manCount);

  switch (locale.languageCode) {
    case 'ja':
    case 'zh':
      return '$manText万';
    default:
      return null;
  }
}

String formatFundYieldPercent(double? ratio) {
  if (ratio == null) {
    return '--';
  }
  final percentage = ratio > 1 ? ratio : ratio * 100;
  final hasFraction = percentage % 1 != 0;
  return '${percentage.toStringAsFixed(hasFraction ? 1 : 0)}%';
}

String _formatYieldRange({
  required double? minimum,
  required double? maximum,
}) {
  final minValue = minimum != null && minimum > 0 ? minimum : null;
  final maxValue = maximum != null && maximum > 0 ? maximum : null;
  if (minValue == null && maxValue == null) {
    return '--';
  }
  if (minValue == null) {
    return formatFundYieldPercent(maxValue);
  }
  if (maxValue == null) {
    return formatFundYieldPercent(minValue);
  }
  if (minValue == maxValue) {
    return formatFundYieldPercent(minValue);
  }
  return '${formatFundYieldPercent(minValue)}～${formatFundYieldPercent(maxValue)}';
}
