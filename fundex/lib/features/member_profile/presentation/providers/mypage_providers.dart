import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/mypage_remote_data_source.dart';
import '../../data/repositories/mypage_repository_impl.dart';
import '../../domain/entities/mypage_models.dart';
import '../../domain/repositories/mypage_repository.dart';
import '../../domain/usecases/fetch_mypage_apply_list_usecase.dart';
import '../../domain/usecases/fetch_mypage_investment_list_usecase.dart';
import '../../domain/usecases/fetch_mypage_order_inquiry_list_usecase.dart';

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>((ref) {
  return MyPageRemoteDataSourceImpl(ref.watch(coreHttpClientProvider));
});

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  return MyPageRepositoryImpl(remote: ref.watch(myPageRemoteDataSourceProvider));
});

final fetchMyPageApplyListUseCaseProvider =
    Provider<FetchMyPageApplyListUseCase>((ref) {
      return FetchMyPageApplyListUseCase(ref.watch(myPageRepositoryProvider));
    });

final fetchMyPageOrderInquiryListUseCaseProvider =
    Provider<FetchMyPageOrderInquiryListUseCase>((ref) {
      return FetchMyPageOrderInquiryListUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final fetchMyPageInvestmentListUseCaseProvider =
    Provider<FetchMyPageInvestmentListUseCase>((ref) {
      return FetchMyPageInvestmentListUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final myPageApplyListProvider = FutureProvider<List<MyPageApplyRecord>>((
  ref,
) async {
  return ref.watch(fetchMyPageApplyListUseCaseProvider).call();
});

final myPageOrderInquiryListProvider =
    FutureProvider<List<MyPageOrderInquiryRecord>>((ref) async {
      final user = await ref.watch(currentAuthUserProvider.future);
      final userId = user?.userId;
      if (userId == null) {
        return const <MyPageOrderInquiryRecord>[];
      }
      return ref
          .watch(fetchMyPageOrderInquiryListUseCaseProvider)
          .call(userId: userId);
    });

final myPageInvestmentListProvider =
    FutureProvider<List<MyPageInvestmentRecord>>((ref) async {
      return ref.watch(fetchMyPageInvestmentListUseCaseProvider).call();
    });
