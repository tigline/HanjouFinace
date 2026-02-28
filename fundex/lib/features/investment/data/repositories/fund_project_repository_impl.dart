import '../../domain/entities/fund_project.dart';
import '../../domain/repositories/fund_project_repository.dart';
import '../datasources/fund_project_remote_data_source.dart';

class FundProjectRepositoryImpl implements FundProjectRepository {
  FundProjectRepositoryImpl({required FundProjectRemoteDataSource remote})
    : _remote = remote;

  final FundProjectRemoteDataSource _remote;

  @override
  Future<List<FundProject>> fetchFundProjectList() async {
    final dtos = await _remote.fetchFundProjectList();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<FundProject> fetchFundProjectDetail({required String id}) async {
    final dto = await _remote.fetchFundProjectDetail(id: id);
    return dto.toEntity();
  }
}
