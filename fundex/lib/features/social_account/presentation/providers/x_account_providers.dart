import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/x_account_remote_data_source.dart';
import '../../data/repositories/x_account_repository_impl.dart';
import '../../domain/repositories/x_account_repository.dart';
import '../../domain/usecases/x_account_usecases.dart';
import '../controllers/x_account_controller.dart';
import '../state/x_account_state.dart';

final xAccountRemoteDataSourceProvider = Provider<XAccountRemoteDataSource>((
  ref,
) {
  return XAccountRemoteDataSourceImpl(ref.watch(memberCoreHttpClientProvider));
});

final xAccountRepositoryProvider = Provider<XAccountRepository>((ref) {
  return XAccountRepositoryImpl(ref.watch(xAccountRemoteDataSourceProvider));
});

final xAccountControllerProvider =
    StateNotifierProvider.autoDispose<XAccountController, XAccountState>((ref) {
      final repository = ref.watch(xAccountRepositoryProvider);
      return XAccountController(
        LoadXAccountConnectionUseCase(repository),
        StartXOAuthUseCase(repository),
        DisconnectXAccountUseCase(repository),
      );
    });
