import 'dart:convert';

import '../../domain/entities/fund_project.dart';

class FundProjectDto {
  const FundProjectDto({
    required this.id,
    required this.projectName,
    this.expectedDistributionRatioMax,
    this.expectedDistributionRatioMin,
    this.distributionDate,
    this.investmentPeriod,
    this.scheduledStartDate,
    this.scheduledEndDate,
    this.offeringStartDatetime,
    this.offeringEndDatetime,
    this.typeOfOffering,
    this.offeringMethod,
    this.investmentUnit,
    this.maximumInvestmentPerPerson,
    this.achievementRate,
    this.amountApplication,
    this.currentlySubscribed,
    this.daysRemaining,
    this.projectStatus,
    this.operatingCompany,
    this.operatingCompanyAccount,
    this.periodType,
    this.times,
    this.accountId,
    this.detailData = const <String, Object?>{},
    this.photos = const <String>[],
    this.investorTypes = const <FundProjectInvestorTypeDto>[],
    this.pdfDocuments = const <FundProjectPdfDocumentDto>[],
  });

  factory FundProjectDto.fromJson(Map<String, dynamic> json) {
    return FundProjectDto(
      id: _stringOrEmpty(json['id']),
      projectName: _stringOrEmpty(json['projectName']),
      expectedDistributionRatioMax: _doubleOrNull(
        json['expectedDistributionRatioMax'],
      ),
      expectedDistributionRatioMin: _doubleOrNull(
        json['expectedDistributionRatioMin'],
      ),
      distributionDate: _normalizedOptionalString(json['distributionDate']),
      investmentPeriod: _normalizedOptionalString(json['investmentPeriod']),
      scheduledStartDate: _normalizedOptionalString(json['scheduledStartDate']),
      scheduledEndDate: _normalizedOptionalString(json['scheduledEndDate']),
      offeringStartDatetime: _normalizedOptionalString(
        json['offeringStartDatetime'],
      ),
      offeringEndDatetime: _normalizedOptionalString(
        json['offeringEndDatetime'],
      ),
      typeOfOffering: _normalizedOptionalString(json['typeOfOffering']),
      offeringMethod:
          _normalizedOptionalString(json['offeringMethod']) ??
          _normalizedOptionalString(json['typeOfOffering']),
      investmentUnit: _intOrNull(json['investmentUnit']),
      maximumInvestmentPerPerson: _intOrNull(
        json['maximumInvestmentPerPerson'],
      ),
      achievementRate: _doubleOrNull(json['achievementRate']),
      amountApplication: _intOrNull(json['amountApplication']),
      currentlySubscribed: _intOrNull(json['currentlySubscribed']),
      daysRemaining: _intOrNull(json['daysRemaining']),
      projectStatus: _intOrNull(json['projectStatus']),
      operatingCompany: _normalizedOptionalString(json['operatingCompany']),
      operatingCompanyAccount: _intOrNull(json['operatingCompanyAccount']),
      periodType: _normalizedOptionalString(json['periodType']),
      times: _intOrNull(json['times']),
      accountId: _normalizedOptionalString(json['accountId']),
      detailData: _detailDataFrom(json['detail']),
      photos: _photoUrlsFrom(json['photos']),
      investorTypes: _investorTypesFrom(json['investorTypeList']),
      pdfDocuments: _pdfDocumentsFrom(json['pdfs']),
    );
  }

  final String id;
  final String projectName;
  final double? expectedDistributionRatioMax;
  final double? expectedDistributionRatioMin;
  final String? distributionDate;
  final String? investmentPeriod;
  final String? scheduledStartDate;
  final String? scheduledEndDate;
  final String? offeringStartDatetime;
  final String? offeringEndDatetime;
  final String? typeOfOffering;
  final String? offeringMethod;
  final int? investmentUnit;
  final int? maximumInvestmentPerPerson;
  final double? achievementRate;
  final int? amountApplication;
  final int? currentlySubscribed;
  final int? daysRemaining;
  final int? projectStatus;
  final String? operatingCompany;
  final int? operatingCompanyAccount;
  final String? periodType;
  final int? times;
  final String? accountId;
  final Map<String, Object?> detailData;
  final List<String> photos;
  final List<FundProjectInvestorTypeDto> investorTypes;
  final List<FundProjectPdfDocumentDto> pdfDocuments;

  FundProject toEntity() {
    return FundProject(
      id: id,
      projectName: projectName,
      expectedDistributionRatioMax: expectedDistributionRatioMax,
      expectedDistributionRatioMin: expectedDistributionRatioMin,
      distributionDate: distributionDate,
      investmentPeriod: investmentPeriod,
      scheduledStartDate: scheduledStartDate,
      scheduledEndDate: scheduledEndDate,
      offeringStartDatetime: offeringStartDatetime,
      offeringEndDatetime: offeringEndDatetime,
      typeOfOffering: typeOfOffering,
      offeringMethod: offeringMethod,
      investmentUnit: investmentUnit,
      maximumInvestmentPerPerson: maximumInvestmentPerPerson,
      achievementRate: achievementRate,
      amountApplication: amountApplication,
      currentlySubscribed: currentlySubscribed,
      daysRemaining: daysRemaining,
      projectStatus: projectStatus,
      operatingCompany: operatingCompany,
      operatingCompanyAccount: operatingCompanyAccount,
      periodType: periodType,
      times: times,
      accountId: accountId,
      detailData: Map<String, Object?>.unmodifiable(detailData),
      photos: List<String>.unmodifiable(photos),
      investorTypes: List<FundProjectInvestorType>.unmodifiable(
        investorTypes.map((item) => item.toEntity()),
      ),
      pdfDocuments: List<FundProjectPdfDocument>.unmodifiable(
        pdfDocuments.map((item) => item.toEntity()),
      ),
    );
  }

  static String _stringOrEmpty(Object? value) {
    final normalized = _normalizedOptionalString(value);
    return normalized ?? '';
  }

  static String? _normalizedOptionalString(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }

  static double? _doubleOrNull(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value == null) {
      return null;
    }
    return double.tryParse(value.toString());
  }

  static bool? _boolOrNull(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value == null) {
      return null;
    }
    final text = value.toString().trim().toLowerCase();
    if (text.isEmpty) {
      return null;
    }
    if (text == 'true' || text == '1') {
      return true;
    }
    if (text == 'false' || text == '0') {
      return false;
    }
    return null;
  }

  static Map<String, Object?> _detailDataFrom(Object? value) {
    final map = _mapOrNull(value);
    if (map != null) {
      return Map<String, Object?>.unmodifiable(map);
    }

    final raw = _normalizedOptionalString(value);
    if (raw == null) {
      return const <String, Object?>{};
    }

    try {
      final decoded = jsonDecode(raw);
      final decodedMap = _mapOrNull(decoded);
      if (decodedMap == null || decodedMap.isEmpty) {
        return const <String, Object?>{};
      }
      return Map<String, Object?>.unmodifiable(decodedMap);
    } on FormatException {
      return const <String, Object?>{};
    }
  }

  static Map<String, dynamic>? _mapOrNull(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static List<String> _toStringList(Object? value) {
    if (value is List) {
      final list = value
          .map<String?>((item) => _normalizedOptionalString(item))
          .whereType<String>()
          .toList(growable: false);
      return List<String>.unmodifiable(list);
    }
    final single = _normalizedOptionalString(value);
    if (single == null) {
      return const <String>[];
    }
    return List<String>.unmodifiable(<String>[single]);
  }

  static List<String> _photoUrlsFrom(Object? value) {
    if (value is! List) {
      return const <String>[];
    }
    final urls = <String>[];
    for (final item in value) {
      if (item is String) {
        final normalized = _normalizedOptionalString(item);
        if (normalized != null) {
          urls.add(normalized);
        }
        continue;
      }
      final json = _mapOrNull(item);
      if (json == null) {
        continue;
      }
      final url =
          _normalizedOptionalString(json['url']) ??
          _normalizedOptionalString(json['photoUrl']) ??
          _normalizedOptionalString(json['src']);
      if (url != null) {
        urls.add(url);
      }
    }
    return List<String>.unmodifiable(urls);
  }

  static List<FundProjectInvestorTypeDto> _investorTypesFrom(Object? value) {
    if (value is! List) {
      return const <FundProjectInvestorTypeDto>[];
    }

    final list = <FundProjectInvestorTypeDto>[];
    for (final item in value) {
      final json = _mapOrNull(item);
      if (json == null) {
        continue;
      }
      list.add(FundProjectInvestorTypeDto.fromJson(json));
    }
    return List<FundProjectInvestorTypeDto>.unmodifiable(list);
  }

  static List<FundProjectPdfDocumentDto> _pdfDocumentsFrom(Object? value) {
    if (value is! List) {
      return const <FundProjectPdfDocumentDto>[];
    }

    final list = <FundProjectPdfDocumentDto>[];
    for (final item in value) {
      final json = _mapOrNull(item);
      if (json == null) {
        continue;
      }
      list.add(FundProjectPdfDocumentDto.fromJson(json));
    }
    return List<FundProjectPdfDocumentDto>.unmodifiable(list);
  }
}

class FundProjectInvestorTypeDto {
  const FundProjectInvestorTypeDto({
    this.id,
    this.projectId,
    this.investorType,
    this.investorCode,
    this.earningsType,
    this.earningsRadio,
    this.interestRadio,
    this.isOpen,
    this.isOpenType,
    this.currentAmountApplication,
  });

  factory FundProjectInvestorTypeDto.fromJson(Map<String, dynamic> json) {
    return FundProjectInvestorTypeDto(
      id: FundProjectDto._normalizedOptionalString(json['id']),
      projectId: FundProjectDto._normalizedOptionalString(json['projectId']),
      investorType: FundProjectDto._normalizedOptionalString(
        json['investorType'],
      ),
      investorCode: FundProjectDto._normalizedOptionalString(
        json['investorCode'],
      ),
      earningsType: FundProjectDto._normalizedOptionalString(
        json['earningsType'],
      ),
      earningsRadio: FundProjectDto._doubleOrNull(json['earningsRadio']),
      interestRadio: FundProjectDto._doubleOrNull(json['interestRadio']),
      isOpen: FundProjectDto._boolOrNull(json['isOpen']),
      isOpenType: FundProjectDto._intOrNull(json['isOpenType']),
      currentAmountApplication: FundProjectDto._intOrNull(
        json['currentAmountApplication'],
      ),
    );
  }

  final String? id;
  final String? projectId;
  final String? investorType;
  final String? investorCode;
  final String? earningsType;
  final double? earningsRadio;
  final double? interestRadio;
  final bool? isOpen;
  final int? isOpenType;
  final int? currentAmountApplication;

  FundProjectInvestorType toEntity() {
    return FundProjectInvestorType(
      id: id,
      projectId: projectId,
      investorType: investorType,
      investorCode: investorCode,
      earningsType: earningsType,
      earningsRadio: earningsRadio,
      interestRadio: interestRadio,
      isOpen: isOpen,
      isOpenType: isOpenType,
      currentAmountApplication: currentAmountApplication,
    );
  }
}

class FundProjectPdfDocumentDto {
  const FundProjectPdfDocumentDto({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <String>[],
  });

  factory FundProjectPdfDocumentDto.fromJson(Map<String, dynamic> json) {
    return FundProjectPdfDocumentDto(
      projectId: FundProjectDto._normalizedOptionalString(json['projectId']),
      type: FundProjectDto._intOrNull(json['type']),
      description: FundProjectDto._normalizedOptionalString(json['desc']),
      urls: FundProjectDto._toStringList(json['urls']),
    );
  }

  final String? projectId;
  final int? type;
  final String? description;
  final List<String> urls;

  FundProjectPdfDocument toEntity() {
    return FundProjectPdfDocument(
      projectId: projectId,
      type: type,
      description: description,
      urls: List<String>.unmodifiable(urls),
    );
  }
}
