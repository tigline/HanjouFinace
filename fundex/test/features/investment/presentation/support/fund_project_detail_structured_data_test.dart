import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/presentation/support/fund_project_detail_structured_data.dart';

void main() {
  group('FundProjectDetailStructuredData', () {
    test('parses detail map fields and house list', () {
      final data = FundProjectDetailStructuredData.fromMap(
        const <String, Object?>{
          'houselist': <Map<String, Object?>>[
            <String, Object?>{
              'propertyName': 'Mr.T 白馬 Amber Mizuhou I-A',
              'location': '白馬村北城',
              'transportation': 'JR白馬駅から車約6分',
              'landCategory': '宅地',
              'area': '416.64㎡',
              'rights': '所有権',
              'structure': '木造2階建',
              'floorArea': '1F 138.72㎡ / 2F 157.48㎡',
              'builtYearAndMonth': '建設中',
              'landUseZone': '指定なし',
              'buildingCoverageRatio': '60%',
              'floorAreaRatio': '200%',
              'operationType': 2,
              'landlord': 'FUNDEX株式会社',
              'tenant': '株式会社JADE GROUP',
              'contractType': '業務運営委託',
              'contractPeriod': '2026年1月1日から期間未定',
              'monthlyRent': '22,000,000円',
              'methodOfContractAmendment': '更新条項あり',
              'otherImportantMatters': 'なし',
            },
          ],
          'housenum': 3,
          'propertyPrice': '1,266,000,000円',
          'totalInvestment': '1,250,000,000円',
          'rentalIncome': '0円',
          'estimatedAmount': '1,513,000,000円',
          'total1': '1,513,000,000円',
          'buildingCost': '994,320,000円',
          'landMiscellaneouscost': '168,270,000円',
          'designcost': '826,050,000円',
          'maintenanceManagementFee': '50,860,000円',
          'publicUtilitiesTaxes': '-',
          'fireInsurancePremium': '1,000,000円',
          'brokerageFee': '49,930,000円',
          'amFee': '13,200,000円',
          'amFee1': '6,600,000円',
          'amFee2': '6,600,000円',
          'amtesuryo': '5,000,000円',
          'publicOfferingFee': '13,200,000円',
          'marketingcosts': '49,930,000円',
          'accountantFee': '165,000円',
          'consignmentFee': '45,000,000円',
          'normalconsignmentFee': '10,000,000円',
          'fundDdministratorFEE': '15,500,000円',
          'miscellaneousExpenses': '33,895,000円',
          'sellExpenses': '20,000,000円',
          'other': '5,000,000円',
          'total2': '1,266,000,000円',
          'distributedCapital': '247,000,000円',
        },
      );

      expect(data.houseList, hasLength(1));
      expect(data.houseCount, 3);
      expect(data.resolvedHouseCount, 3);
      expect(data.houseList.first.propertyName, 'Mr.T 白馬 Amber Mizuhou I-A');
      expect(data.houseList.first.operationType, 2);
      expect(data.propertyPrice, '1,266,000,000円');
      expect(data.totalIncome, '1,513,000,000円');
      expect(data.fundAdministratorFee, '15,500,000円');
      expect(data.distributedCapital, '247,000,000円');
    });

    test('uses fallback keys and safe defaults when values are missing', () {
      final data = FundProjectDetailStructuredData.fromMap(
        const <String, Object?>{
          'houselist': <Map<String, Object?>>[
            <String, Object?>{'propertyName': 'Only House'},
          ],
          'fundAdministratorFEE': '900,000円',
        },
      );

      expect(data.resolvedHouseCount, 1);
      expect(data.fundAdministratorFee, '900,000円');
      expect(data.rentalIncome, isEmpty);
      expect(data.houseList.first.location, isEmpty);
    });
  });
}
