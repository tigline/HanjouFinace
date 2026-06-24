import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/social_account/domain/entities/x_account_models.dart';
import 'package:fundex/features/social_account/domain/repositories/x_account_repository.dart';
import 'package:fundex/features/social_account/domain/usecases/x_account_usecases.dart';
import 'package:fundex/features/social_account/presentation/controllers/x_account_controller.dart';

class _FakeXAccountRepository implements XAccountRepository {
  XAccountConnection connection = const XAccountConnection.disconnected();

  @override
  Future<XAccountConnection> fetchConnection() async => connection;

  @override
  Future<XOAuthAuthorization> startOAuth() async {
    return XOAuthAuthorization(
      authorizationUri: Uri.parse('https://x.com/i/oauth2/authorize'),
    );
  }
}

void main() {
  test('starts OAuth and confirms binding from account state', () async {
    final repository = _FakeXAccountRepository();
    final controller = XAccountController(
      LoadXAccountConnectionUseCase(repository),
      StartXOAuthUseCase(repository),
    );
    addTearDown(controller.dispose);
    await pumpEventQueue();

    final authorization = await controller.startOAuth();

    expect(authorization?.authorizationUri.host, 'x.com');
    expect(controller.state.isAwaitingAuthorization, isTrue);
    expect(controller.state.connection.status, XAccountStatus.connecting);

    repository.connection = const XAccountConnection(
      status: XAccountStatus.connected,
      username: 'stellavia',
    );
    final connected = await controller.confirmAuthorization(
      retryDelay: Duration.zero,
    );

    expect(connected, isTrue);
    expect(controller.state.connection.isConnected, isTrue);
    expect(controller.state.connection.username, 'stellavia');
    expect(controller.state.isAwaitingAuthorization, isFalse);
  });
}
