import 'package:company_api_runtime/company_api_runtime.dart';

import '../../domain/entities/x_account_models.dart';
import '../../domain/repositories/x_account_repository.dart';
import '../datasources/x_account_remote_data_source.dart';

class XAccountRepositoryImpl implements XAccountRepository {
  const XAccountRepositoryImpl(this._remote);

  final XAccountRemoteDataSource _remote;

  @override
  Future<XAccountConnection> fetchConnection() async {
    return _mapConnection(await _remote.fetchAccount());
  }

  @override
  Future<XBindingAttempt> startBinding({required Uri callbackUri}) async {
    final dto = await _remote.startBinding(callbackUri: callbackUri.toString());
    final authorizationUri = Uri.tryParse(dto.authorizationUrl);
    if (authorizationUri == null || !authorizationUri.hasScheme) {
      throw StateError('Invalid X authorization URL.');
    }
    return XBindingAttempt(
      attemptId: dto.attemptId,
      authorizationUri: authorizationUri,
      expiresAt: dto.expiresAt,
    );
  }

  @override
  Future<XBindingStatus> fetchBindingStatus({required String attemptId}) async {
    final dto = await _remote.fetchBindingStatus(attemptId: attemptId);
    return XBindingStatus(
      attemptId: dto.attemptId.isEmpty ? attemptId : dto.attemptId,
      status: _mapStatus(dto.status),
      connection: _mapConnection(dto.connection),
      errorCode: dto.errorCode,
    );
  }

  @override
  Future<void> disconnect() => _remote.disconnectAccount();

  XAccountConnection _mapConnection(XAccountConnectionDto dto) {
    return XAccountConnection(
      status: _mapStatus(dto.status),
      xUserId: dto.xUserId,
      username: dto.username,
      displayName: dto.displayName,
      avatarUrl: dto.avatarUrl,
      connectedAt: dto.connectedAt,
    );
  }

  XAccountStatus _mapStatus(XAccountConnectionStatus status) {
    return switch (status) {
      XAccountConnectionStatus.disconnected => XAccountStatus.disconnected,
      XAccountConnectionStatus.connecting => XAccountStatus.connecting,
      XAccountConnectionStatus.connected => XAccountStatus.connected,
      XAccountConnectionStatus.expired => XAccountStatus.expired,
    };
  }
}
