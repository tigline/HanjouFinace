import '../entities/fund_project.dart';

abstract class FundProjectRepository {
  Future<List<FundProject>> fetchFundProjectList();
  Future<FundProject> fetchFundProjectDetail({required String id});
}
