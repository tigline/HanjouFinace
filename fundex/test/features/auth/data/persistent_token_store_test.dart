import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/auth/persistent_token_store.dart';

void main() {
  test('persists, reads and clears token pair', () async {
    final keyValueStorage = InMemoryKeyValueStorage();
    final tokenStore = PersistentTokenStore(keyValueStorage);

    expect(await tokenStore.readAccessToken(), isNull);
    expect(await tokenStore.readRefreshToken(), isNull);

    await tokenStore.save(
      const TokenPair(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
      ),
    );

    expect(await tokenStore.readAccessToken(), 'access-token');
    expect(await tokenStore.readRefreshToken(), 'refresh-token');

    await tokenStore.clear();

    expect(await tokenStore.readAccessToken(), isNull);
    expect(await tokenStore.readRefreshToken(), isNull);
  });
}
