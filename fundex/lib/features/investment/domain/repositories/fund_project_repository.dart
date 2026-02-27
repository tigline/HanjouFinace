import '../entities/fund_project.dart';

abstract class FundProjectRepository {
  Future<List<FundProject>> fetchFundProjectList();
}
