import 'package:meta/meta.dart';

@immutable
class FundProject {
  const FundProject({
    required this.id,
    required this.projectName,
    this.expectedDistributionRatioMax,
    this.expectedDistributionRatioMin,
    this.investmentPeriod,
    this.scheduledStartDate,
    this.scheduledEndDate,
    this.offeringStartDatetime,
    this.offeringEndDatetime,
    this.offeringMethod,
    this.investmentUnit,
    this.maximumInvestmentPerPerson,
    this.achievementRate,
    this.amountApplication,
    this.currentlySubscribed,
    this.daysRemaining,
    this.projectStatus,
    this.operatingCompany,
    this.periodType,
    this.times,
    this.photos = const <String>[],
    this.investorTypes = const <FundProjectInvestorType>[],
    this.pdfDocuments = const <FundProjectPdfDocument>[],
  });

  final String id;
  final String projectName;
  final double? expectedDistributionRatioMax;
  final double? expectedDistributionRatioMin;
  final String? investmentPeriod;
  final String? scheduledStartDate;
  final String? scheduledEndDate;
  final String? offeringStartDatetime;
  final String? offeringEndDatetime;
  final String? offeringMethod;
  final int? investmentUnit;
  final int? maximumInvestmentPerPerson;
  final double? achievementRate;
  final int? amountApplication;
  final int? currentlySubscribed;
  final int? daysRemaining;
  final int? projectStatus;
  final String? operatingCompany;
  final String? periodType;
  final int? times;
  final List<String> photos;
  final List<FundProjectInvestorType> investorTypes;
  final List<FundProjectPdfDocument> pdfDocuments;
}

@immutable
class FundProjectInvestorType {
  const FundProjectInvestorType({
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
}

@immutable
class FundProjectPdfDocument {
  const FundProjectPdfDocument({
    this.projectId,
    this.type,
    this.description,
    this.urls = const <String>[],
  });

  final String? projectId;
  final int? type;
  final String? description;
  final List<String> urls;
}
