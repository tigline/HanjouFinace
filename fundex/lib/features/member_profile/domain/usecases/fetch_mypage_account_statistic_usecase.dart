import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchMyPageAccountStatisticUseCase {
  const FetchMyPageAccountStatisticUseCase(this._repository);

  final MyPageRepository _repository;

  Future<MyPageAccountStatistic> call() {
    return _repository.fetchAccountStatistic();
  }
}
