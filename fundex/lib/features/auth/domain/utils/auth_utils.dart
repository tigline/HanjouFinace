import '../../../auth/domain/entities/auth_user.dart';

String resolveAvatarText(AuthUser? user) {
  final candidates = <String>[
    user?.lastName ?? '',
    user?.username ?? '',
    user?.firstName ?? '',
    user?.id ?? '',
  ];
  for (final candidate in candidates) {
    final text = candidate.trim();
    if (text.isNotEmpty) {
      return String.fromCharCode(text.runes.first);
    }
  }
  return '田';
}

String resolveCurrentUserId(AuthUser? user) {
  final candidates = <String>[
    user?.userId?.toString() ?? '',
    user?.memberId?.toString() ?? '',
    user?.id ?? '',
    user?.accountId ?? '',
    user?.username ?? '',
  ];
  for (final candidate in candidates) {
    final text = candidate.trim();
    if (text.isNotEmpty) {
      return text;
    }
  }
  return '';
}