import '../../domain/entities/mypage_models.dart';
import '../../domain/repositories/mypage_repository.dart';
import '../datasources/mypage_remote_data_source.dart';

class MyPageRepositoryImpl implements MyPageRepository {
  MyPageRepositoryImpl({required MyPageRemoteDataSource remote})
    : _remote = remote;

  final MyPageRemoteDataSource _remote;

  @override
  Future<List<MyPageApplyRecord>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final dtos = await _remote.fetchApplyList(
      startPage: startPage,
      limit: limit,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<List<MyPageOrderInquiryRecord>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  }) async {
    final dtos = await _remote.fetchOrderInquiryList(
      userId: userId,
      startPage: startPage,
      limit: limit,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<List<MyPageInvestmentRecord>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final dtos = await _remote.fetchInvestmentList(
      startPage: startPage,
      limit: limit,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }
}
