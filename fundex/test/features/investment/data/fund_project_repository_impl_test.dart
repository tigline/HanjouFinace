import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/data/datasources/fund_project_remote_data_source.dart';
import 'package:fundex/features/investment/data/models/fund_project_dto.dart';
import 'package:fundex/features/investment/data/repositories/fund_project_repository_impl.dart';

class _FakeFundProjectRemoteDataSource implements FundProjectRemoteDataSource {
  List<FundProjectDto> result = const <FundProjectDto>[];
  int callCount = 0;

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    callCount += 1;
    return result;
  }
}

void main() {
  group('FundProjectRepositoryImpl', () {
    test('fetchFundProjectList maps DTO list to domain entities', () async {
      final remote = _FakeFundProjectRemoteDataSource()
        ..result = <FundProjectDto>[
          const FundProjectDto(
            id: 'p1',
            projectName: '繁星優選Fund商品20241123',
            expectedDistributionRatioMax: 0.02,
            expectedDistributionRatioMin: 0.01,
            investmentUnit: 100000,
            maximumInvestmentPerPerson: 100,
            projectStatus: 4,
            investorTypes: <FundProjectInvestorTypeDto>[
              FundProjectInvestorTypeDto(
                id: 'i1',
                investorType: 'INVESTMENT',
                investorCode: '優先出資者A',
              ),
            ],
            pdfDocuments: <FundProjectPdfDocumentDto>[
              FundProjectPdfDocumentDto(
                projectId: 'p1',
                type: 1,
                description: '契約成立前書面',
                urls: <String>['https://cdn.example.com/a.pdf'],
              ),
            ],
          ),
        ];

      final repository = FundProjectRepositoryImpl(remote: remote);

      final entities = await repository.fetchFundProjectList();

      expect(remote.callCount, 1);
      expect(entities, hasLength(1));
      expect(entities.first.id, 'p1');
      expect(entities.first.projectName, '繁星優選Fund商品20241123');
      expect(entities.first.projectStatus, 4);
      expect(entities.first.investorTypes, hasLength(1));
      expect(entities.first.investorTypes.first.investorCode, '優先出資者A');
      expect(entities.first.pdfDocuments, hasLength(1));
      expect(entities.first.pdfDocuments.first.description, '契約成立前書面');
      expect(entities.first.pdfDocuments.first.urls, <String>[
        'https://cdn.example.com/a.pdf',
      ]);
    });
  });
}
