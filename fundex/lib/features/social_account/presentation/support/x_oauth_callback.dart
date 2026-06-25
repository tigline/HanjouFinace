import 'package:flutter_riverpod/flutter_riverpod.dart';

const xOAuthUniversalLinkScheme = 'https';
const xOAuthUniversalLinkHost = 'stellavia.co.jp';
const xOAuthUniversalLinkPath = '/app/social/x/callback';
const xOAuthUniversalLinkUrl =
    '$xOAuthUniversalLinkScheme://'
    '$xOAuthUniversalLinkHost'
    '$xOAuthUniversalLinkPath';

const xOAuthFallbackScheme = 'stellavia';
const xOAuthFallbackHost = 'social';
const xOAuthFallbackPath = '/x/callback';
const xOAuthFallbackUrl =
    '$xOAuthFallbackScheme://$xOAuthFallbackHost$xOAuthFallbackPath';

final xOAuthCallbackSignalProvider = StateProvider<int>((ref) => 0);

bool isXOAuthCallbackUri(Uri uri) {
  return _isXOAuthUniversalLinkUri(uri) || _isXOAuthFallbackUri(uri);
}

bool _isXOAuthUniversalLinkUri(Uri uri) {
  return uri.scheme == xOAuthUniversalLinkScheme &&
      uri.host == xOAuthUniversalLinkHost &&
      uri.path == xOAuthUniversalLinkPath;
}

bool _isXOAuthFallbackUri(Uri uri) {
  return uri.scheme == xOAuthFallbackScheme &&
      uri.host == xOAuthFallbackHost &&
      uri.path == xOAuthFallbackPath;
}
