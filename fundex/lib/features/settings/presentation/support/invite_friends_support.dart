import 'package:core_network/core_network.dart';

enum InviteFriendsLoadFailureKind { forbidden, network, other }

InviteFriendsLoadFailureKind classifyInviteFriendsLoadError(Object error) {
  final failure = switch (error) {
    NetworkFailure value => value,
    DioException value when value.error is NetworkFailure =>
      value.error! as NetworkFailure,
    _ => null,
  };

  if (failure?.type == NetworkFailureType.forbidden ||
      (error is DioException && error.response?.statusCode == 403)) {
    return InviteFriendsLoadFailureKind.forbidden;
  }

  if (failure != null) {
    return switch (failure.type) {
      NetworkFailureType.connectionTimeout ||
      NetworkFailureType.sendTimeout ||
      NetworkFailureType.receiveTimeout ||
      NetworkFailureType.connectionError ||
      NetworkFailureType.networkAccessDenied =>
        InviteFriendsLoadFailureKind.network,
      _ => InviteFriendsLoadFailureKind.other,
    };
  }

  return InviteFriendsLoadFailureKind.other;
}

Uri buildInviteRegistrationUri({
  required String apiBaseUrl,
  required String inviteCode,
}) {
  final baseUri = Uri.tryParse(apiBaseUrl.trim());
  final normalizedCode = inviteCode.trim();
  if (baseUri == null || !baseUri.hasScheme || baseUri.host.isEmpty) {
    return Uri.https('stellavia.co.jp', '/register', <String, String>{
      'ref': normalizedCode,
    });
  }
  return baseUri.replace(
    path: '/register',
    query: null,
    queryParameters: <String, String>{'ref': normalizedCode},
    fragment: null,
  );
}
