import 'package:core_network/core_network.dart';
import 'package:core_storage/core_storage.dart';

class PersistentTokenStore implements TokenStore {
  PersistentTokenStore(
    this._storage, {
    this.accessTokenKey = 'auth_access_token',
    this.refreshTokenKey = 'auth_refresh_token',
  });

  final KeyValueStorage _storage;
  final String accessTokenKey;
  final String refreshTokenKey;

  @override
  Future<void> clear() async {
    await _storage.remove(accessTokenKey);
    await _storage.remove(refreshTokenKey);
  }

  @override
  Future<String?> readAccessToken() {
    return _storage.read(accessTokenKey);
  }

  @override
  Future<String?> readRefreshToken() {
    return _storage.read(refreshTokenKey);
  }

  @override
  Future<void> save(TokenPair pair) async {
    await _storage.write(accessTokenKey, pair.accessToken);
    await _storage.write(refreshTokenKey, pair.refreshToken);
  }
}
