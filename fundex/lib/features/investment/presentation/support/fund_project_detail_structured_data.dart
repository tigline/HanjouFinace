import 'package:meta/meta.dart';

@immutable
class FundProjectDetailStructuredData {
  const FundProjectDetailStructuredData({
    required this.houseList,
    required this.houseCount,
    required this.propertyPrice,
    required this.totalInvestment,
    required this.rentalIncome,
    required this.estimatedAmount,
    required this.totalIncome,
    required this.buildingCost,
    required this.landMiscellaneousCost,
    required this.designCost,
    required this.maintenanceManagementFee,
    required this.publicUtilitiesTaxes,
    required this.fireInsurancePremium,
    required this.brokerageFee,
    required this.amFee,
    required this.amFeeYear1,
    required this.amFeeYear2,
    required this.amCommissionFee,
    required this.publicOfferingFee,
    required this.marketingCosts,
    required this.accountantFee,
    required this.consignmentFee,
    required this.normalConsignmentFee,
    required this.fundAdministratorFee,
    required this.miscellaneousExpenses,
    required this.sellExpenses,
    required this.otherExpenses,
    required this.totalExpense,
    required this.distributedCapital,
  });

  factory FundProjectDetailStructuredData.fromMap(Map<String, Object?> map) {
    return FundProjectDetailStructuredData(
      houseList: _houseListFrom(map['houselist']),
      houseCount: _intOrNull(map['housenum']) ?? 0,
      propertyPrice: _stringOrEmpty(map['propertyPrice']),
      totalInvestment: _stringOrEmpty(map['totalInvestment']),
      rentalIncome: _stringOrEmpty(map['rentalIncome']),
      estimatedAmount: _stringOrEmpty(map['estimatedAmount']),
      totalIncome: _stringOrEmpty(map['total1']),
      buildingCost: _stringOrEmpty(map['buildingCost']),
      landMiscellaneousCost: _stringOrEmpty(map['landMiscellaneouscost']),
      designCost: _stringOrEmpty(map['designcost']),
      maintenanceManagementFee: _stringOrEmpty(map['maintenanceManagementFee']),
      publicUtilitiesTaxes: _stringOrEmpty(map['publicUtilitiesTaxes']),
      fireInsurancePremium: _stringOrEmpty(map['fireInsurancePremium']),
      brokerageFee: _stringOrEmpty(map['brokerageFee']),
      amFee: _stringOrEmpty(map['amFee']),
      amFeeYear1: _stringOrEmpty(map['amFee1']),
      amFeeYear2: _stringOrEmpty(map['amFee2']),
      amCommissionFee: _stringOrEmpty(map['amtesuryo']),
      publicOfferingFee: _stringOrEmpty(map['publicOfferingFee']),
      marketingCosts: _stringOrEmpty(map['marketingcosts']),
      accountantFee: _stringOrEmpty(map['accountantFee']),
      consignmentFee: _stringOrEmpty(map['consignmentFee']),
      normalConsignmentFee: _stringOrEmpty(map['normalconsignmentFee']),
      fundAdministratorFee: _stringOrEmpty(
        map['fundDdministratorFEE'] ?? map['fundAdministratorFEE'],
      ),
      miscellaneousExpenses: _stringOrEmpty(map['miscellaneousExpenses']),
      sellExpenses: _stringOrEmpty(map['sellExpenses']),
      otherExpenses: _stringOrEmpty(map['other']),
      totalExpense: _stringOrEmpty(map['total2']),
      distributedCapital: _stringOrEmpty(map['distributedCapital']),
    );
  }

  final List<FundProjectHouseStructuredData> houseList;
  final int houseCount;
  final String propertyPrice;
  final String totalInvestment;
  final String rentalIncome;
  final String estimatedAmount;
  final String totalIncome;
  final String buildingCost;
  final String landMiscellaneousCost;
  final String designCost;
  final String maintenanceManagementFee;
  final String publicUtilitiesTaxes;
  final String fireInsurancePremium;
  final String brokerageFee;
  final String amFee;
  final String amFeeYear1;
  final String amFeeYear2;
  final String amCommissionFee;
  final String publicOfferingFee;
  final String marketingCosts;
  final String accountantFee;
  final String consignmentFee;
  final String normalConsignmentFee;
  final String fundAdministratorFee;
  final String miscellaneousExpenses;
  final String sellExpenses;
  final String otherExpenses;
  final String totalExpense;
  final String distributedCapital;

  bool get hasHouseList => houseList.isNotEmpty;
  int get resolvedHouseCount => houseCount > 0 ? houseCount : houseList.length;
}

@immutable
class FundProjectHouseStructuredData {
  const FundProjectHouseStructuredData({
    required this.propertyName,
    required this.location,
    required this.transportation,
    required this.landCategory,
    required this.area,
    required this.rights,
    required this.structure,
    required this.floorArea,
    required this.builtYearAndMonth,
    required this.landUseZone,
    required this.buildingCoverageRatio,
    required this.floorAreaRatio,
    required this.operationType,
    required this.landlord,
    required this.tenant,
    required this.contractType,
    required this.contractPeriod,
    required this.monthlyRent,
    required this.methodOfContractAmendment,
    required this.otherImportantMatters,
  });

  factory FundProjectHouseStructuredData.fromMap(Map<String, Object?> map) {
    return FundProjectHouseStructuredData(
      propertyName: _stringOrEmpty(map['propertyName']),
      location: _stringOrEmpty(map['location']),
      transportation: _stringOrEmpty(map['transportation']),
      landCategory: _stringOrEmpty(map['landCategory']),
      area: _stringOrEmpty(map['area']),
      rights: _stringOrEmpty(map['rights']),
      structure: _stringOrEmpty(map['structure']),
      floorArea: _stringOrEmpty(map['floorArea']),
      builtYearAndMonth: _stringOrEmpty(map['builtYearAndMonth']),
      landUseZone: _stringOrEmpty(map['landUseZone']),
      buildingCoverageRatio: _stringOrEmpty(map['buildingCoverageRatio']),
      floorAreaRatio: _stringOrEmpty(map['floorAreaRatio']),
      operationType: _intOrNull(map['operationType']),
      landlord: _stringOrEmpty(map['landlord']),
      tenant: _stringOrEmpty(map['tenant']),
      contractType: _stringOrEmpty(map['contractType']),
      contractPeriod: _stringOrEmpty(map['contractPeriod']),
      monthlyRent: _stringOrEmpty(map['monthlyRent']),
      methodOfContractAmendment: _stringOrEmpty(
        map['methodOfContractAmendment'],
      ),
      otherImportantMatters: _stringOrEmpty(map['otherImportantMatters']),
    );
  }

  final String propertyName;
  final String location;
  final String transportation;
  final String landCategory;
  final String area;
  final String rights;
  final String structure;
  final String floorArea;
  final String builtYearAndMonth;
  final String landUseZone;
  final String buildingCoverageRatio;
  final String floorAreaRatio;
  final int? operationType;
  final String landlord;
  final String tenant;
  final String contractType;
  final String contractPeriod;
  final String monthlyRent;
  final String methodOfContractAmendment;
  final String otherImportantMatters;
}

List<FundProjectHouseStructuredData> _houseListFrom(Object? value) {
  if (value is! List) {
    return const <FundProjectHouseStructuredData>[];
  }

  final list = <FundProjectHouseStructuredData>[];
  for (final item in value) {
    final map = _mapOrNull(item);
    if (map == null || map.isEmpty) {
      continue;
    }
    list.add(FundProjectHouseStructuredData.fromMap(map));
  }
  return List<FundProjectHouseStructuredData>.unmodifiable(list);
}

Map<String, Object?>? _mapOrNull(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map<String, dynamic>) {
    return Map<String, Object?>.from(value);
  }
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }
  return null;
}

String _stringOrEmpty(Object? value) {
  if (value == null) {
    return '';
  }
  final text = value.toString().trim();
  return text;
}

int? _intOrNull(Object? value) {
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
