import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/social_account/domain/entities/x_account_models.dart';
import 'package:fundex/features/social_account/domain/repositories/x_account_repository.dart';
import 'package:fundex/features/social_account/domain/usecases/x_account_usecases.dart';
import 'package:fundex/features/social_account/presentation/controllers/x_account_controller.dart';
import 'package:fundex/features/social_account/presentation/support/x_oauth_callback.dart';

class _FakeXAccountRepository implements XAccountRepository {
  XAccountConnection connection = const XAccountConnection.disconnected();

  @override
  Future<void> disconnect() async {
    connection = const XAccountConnection.disconnected();
  }

  @override
  Future<XAccountConnection> fetchConnection() async => connection;

  @override
  Future<XBindingStatus> fetchBindingStatus({required String attemptId}) async {
    connection = const XAccountConnection(
      status: XAccountStatus.connected,
      xUserId: '42',
      username: 'stellavia',
    );
    return XBindingStatus(
      attemptId: attemptId,
      status: XAccountStatus.connected,
      connection: connection,
    );
  }

  @override
  Future<XBindingAttempt> startBinding({required Uri callbackUri}) async {
    expect(callbackUri, XOAuthCallback.callbackUri);
    return XBindingAttempt(
      attemptId: 'attempt-1',
      authorizationUri: Uri.parse('https://x.com/i/oauth2/authorize'),
    );
  }
}

void main() {
  test('starts binding and resolves the matching callback', () async {
    final repository = _FakeXAccountRepository();
    final controller = XAccountController(
      LoadXAccountConnectionUseCase(repository),
      StartXAccountBindingUseCase(repository),
      CompleteXAccountBindingUseCase(repository),
      DisconnectXAccountUseCase(repository),
    );
    addTearDown(controller.dispose);
    await pumpEventQueue();

    final attempt = await controller.startBinding();

    expect(attempt?.attemptId, 'attempt-1');
    expect(controller.state.activeAttemptId, 'attempt-1');
    expect(controller.state.connection.status, XAccountStatus.connecting);

    final connected = await controller.handleCallback(
      XOAuthCallback(
        attemptId: 'attempt-1',
        result: 'success',
        receivedAt: DateTime.now(),
      ),
    );

    expect(connected, isTrue);
    expect(controller.state.connection.isConnected, isTrue);
    expect(controller.state.connection.username, 'stellavia');
    expect(controller.state.activeAttemptId, isNull);
  });
}
