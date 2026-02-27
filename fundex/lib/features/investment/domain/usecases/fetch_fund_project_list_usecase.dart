import '../entities/fund_project.dart';
import '../repositories/fund_project_repository.dart';

class FetchFundProjectListUseCase {
  const FetchFundProjectListUseCase(this._repository);

  final FundProjectRepository _repository;

  Future<List<FundProject>> call() {
    return _repository.fetchFundProjectList();
  }
}
