import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

@immutable
class FundDetailStaticContent {
  const FundDetailStaticContent({
    required this.riskSection,
    required this.legalSections,
  });

  factory FundDetailStaticContent.fromJson(Map<String, dynamic> json) {
    return FundDetailStaticContent(
      riskSection: FundDetailRiskSection.fromJson(
        _mapOrEmpty(json['riskSection']),
      ),
      legalSections: _listOfMap(
        json['legalSections'],
      ).map(FundDetailLegalSection.fromJson).toList(growable: false),
    );
  }

  final FundDetailRiskSection riskSection;
  final List<FundDetailLegalSection> legalSections;

  static Future<FundDetailStaticContent> load(String languageCode) async {
    final normalized = switch (languageCode) {
      'ja' => 'ja',
      'zh' => 'zh',
      _ => 'en',
    };

    try {
      final raw = await rootBundle.loadString(
        'assets/content/fund_detail_static_sections_$normalized.json',
      );
      return FundDetailStaticContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      final raw = await rootBundle.loadString(
        'assets/content/fund_detail_static_sections_ja.json',
      );
      return FundDetailStaticContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    }
  }

  static Map<String, dynamic> _mapOrEmpty(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _listOfMap(Object? value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((Map item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
}

@immutable
class FundDetailRiskSection {
  const FundDetailRiskSection({
    required this.title,
    required this.warning,
    required this.items,
    required this.footnotes,
  });

  factory FundDetailRiskSection.fromJson(Map<String, dynamic> json) {
    return FundDetailRiskSection(
      title: json['title']?.toString() ?? '',
      warning: json['warning']?.toString() ?? '',
      items: FundDetailStaticContent._listOfMap(
        json['items'],
      ).map(FundDetailRiskItem.fromJson).toList(growable: false),
      footnotes: (json['footnotes'] as List<dynamic>? ?? const <dynamic>[])
          .map((Object? item) => item?.toString() ?? '')
          .where((String item) => item.isNotEmpty)
          .toList(growable: false),
    );
  }

  final String title;
  final String warning;
  final List<FundDetailRiskItem> items;
  final List<String> footnotes;
}

@immutable
class FundDetailRiskItem {
  const FundDetailRiskItem({required this.title, required this.body});

  factory FundDetailRiskItem.fromJson(Map<String, dynamic> json) {
    return FundDetailRiskItem(
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  final String title;
  final String body;
}

@immutable
class FundDetailLegalSection {
  const FundDetailLegalSection({
    required this.id,
    required this.title,
    this.body,
    this.rows = const <FundDetailLegalRow>[],
  });

  factory FundDetailLegalSection.fromJson(Map<String, dynamic> json) {
    return FundDetailLegalSection(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      rows: FundDetailStaticContent._listOfMap(
        json['rows'],
      ).map(FundDetailLegalRow.fromJson).toList(growable: false),
    );
  }

  final String id;
  final String title;
  final String? body;
  final List<FundDetailLegalRow> rows;
}

@immutable
class FundDetailLegalRow {
  const FundDetailLegalRow({required this.label, required this.value});

  factory FundDetailLegalRow.fromJson(Map<String, dynamic> json) {
    return FundDetailLegalRow(
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  final String label;
  final String value;
}
