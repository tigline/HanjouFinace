import '../entities/fund_project.dart';
import '../repositories/fund_project_repository.dart';

class FetchFundProjectDetailUseCase {
  const FetchFundProjectDetailUseCase(this._repository);

  final FundProjectRepository _repository;

  Future<FundProject> call({required String id}) {
    return _repository.fetchFundProjectDetail(id: id);
  }
}
