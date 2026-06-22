import 'dart:convert';

import 'package:flutter/services.dart';

class BenefitLotteryStatusContent {
  const BenefitLotteryStatusContent({
    required this.evaluation,
    required this.rules,
    required this.prizeNotice,
    required this.lockedPrizeNotice,
    required this.locked,
    required this.history,
  });

  factory BenefitLotteryStatusContent.fromJson(Map<String, Object?> json) {
    return BenefitLotteryStatusContent(
      evaluation: BenefitLotteryEvaluationContent.fromJson(
        json['evaluation'] as Map<String, Object?>? ??
            const <String, Object?>{},
      ),
      rules: (json['rules'] as List<Object?>? ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
      prizeNotice: json['prizeNotice'] as String? ?? '',
      lockedPrizeNotice: json['lockedPrizeNotice'] as String? ?? '',
      locked: BenefitLotteryLockedContent.fromJson(
        json['locked'] as Map<String, Object?>? ?? const <String, Object?>{},
      ),
      history: (json['history'] as List<Object?>? ?? const <Object?>[])
          .whereType<Map<String, Object?>>()
          .map(BenefitLotteryHistoryItemContent.fromJson)
          .toList(growable: false),
    );
  }

  final BenefitLotteryEvaluationContent evaluation;
  final List<String> rules;
  final String prizeNotice;
  final String lockedPrizeNotice;
  final BenefitLotteryLockedContent locked;
  final List<BenefitLotteryHistoryItemContent> history;
}

class BenefitLotteryEvaluationContent {
  const BenefitLotteryEvaluationContent({
    required this.description,
    required this.factors,
    required this.note,
  });

  factory BenefitLotteryEvaluationContent.fromJson(Map<String, Object?> json) {
    return BenefitLotteryEvaluationContent(
      description: json['description'] as String? ?? '',
      factors: (json['factors'] as List<Object?>? ?? const <Object?>[])
          .whereType<Map<String, Object?>>()
          .map(BenefitLotteryEvaluationFactorContent.fromJson)
          .toList(growable: false),
      note: json['note'] as String? ?? '',
    );
  }

  final String description;
  final List<BenefitLotteryEvaluationFactorContent> factors;
  final String note;
}

class BenefitLotteryEvaluationFactorContent {
  const BenefitLotteryEvaluationFactorContent({
    required this.title,
    required this.subtitle,
  });

  factory BenefitLotteryEvaluationFactorContent.fromJson(
    Map<String, Object?> json,
  ) {
    return BenefitLotteryEvaluationFactorContent(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }

  final String title;
  final String subtitle;
}

class BenefitLotteryLockedContent {
  const BenefitLotteryLockedContent({
    required this.title,
    required this.body,
    required this.ctaEyebrow,
    required this.ctaTitle,
    required this.ctaBody,
  });

  factory BenefitLotteryLockedContent.fromJson(Map<String, Object?> json) {
    return BenefitLotteryLockedContent(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      ctaEyebrow: json['ctaEyebrow'] as String? ?? '',
      ctaTitle: json['ctaTitle'] as String? ?? '',
      ctaBody: json['ctaBody'] as String? ?? '',
    );
  }

  final String title;
  final String body;
  final String ctaEyebrow;
  final String ctaTitle;
  final String ctaBody;
}

class BenefitLotteryHistoryItemContent {
  const BenefitLotteryHistoryItemContent({
    required this.grade,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.tone,
  });

  factory BenefitLotteryHistoryItemContent.fromJson(Map<String, Object?> json) {
    return BenefitLotteryHistoryItemContent(
      grade: json['grade'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      status: json['status'] as String? ?? '',
      tone: json['tone'] as String? ?? '',
    );
  }

  final String grade;
  final String title;
  final String subtitle;
  final String status;
  final String tone;

  bool get isAvailable => tone == 'available';
}

Future<BenefitLotteryStatusContent> loadBenefitLotteryStatusContent(
  String localeName,
) async {
  final raw = await rootBundle.loadString(
    'assets/content/benefit_lottery_status_content.json',
  );
  final root = jsonDecode(raw) as Map<String, Object?>;
  final contentJson =
      root[localeName] as Map<String, Object?>? ??
      root[localeName.split('_').first] as Map<String, Object?>? ??
      root['ja'] as Map<String, Object?>? ??
      const <String, Object?>{};
  return BenefitLotteryStatusContent.fromJson(contentJson);
}
