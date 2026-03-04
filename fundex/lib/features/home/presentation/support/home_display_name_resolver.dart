import 'dart:ui';

import '../../../auth/domain/entities/auth_user.dart';

String resolveHomeDisplayName({
  required Locale locale,
  required AuthUser? user,
}) {
  final languageCode = locale.languageCode.toLowerCase();

  return switch (languageCode) {
    'ja' => _resolveJapaneseDisplayName(user),
    'zh' => _resolveChineseDisplayName(user),
    'en' => _resolveEnglishDisplayName(user),
    _ => _resolveGenericDisplayName(user),
  };
}

String _resolveJapaneseDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.lastName,
        user?.katakana,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'FUNDEX';

  return '$baseNameさん';
}

String _resolveChineseDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.lastName,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'FUNDEX';

  return switch (_resolveGender(user?.sex)) {
    _Gender.female => '$baseName女士',
    _Gender.male => '$baseName先生',
    _Gender.unknown => baseName,
  };
}

String _resolveEnglishDisplayName(AuthUser? user) {
  final baseName =
      _firstNonBlank(<String?>[
        user?.lastNameEn,
        user?.lastName,
        user?.firstNameEn,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'FUNDEX';

  return switch (_resolveGender(user?.sex)) {
    _Gender.female => 'Ms. $baseName',
    _Gender.male => 'Mr. $baseName',
    _Gender.unknown => baseName,
  };
}

String _resolveGenericDisplayName(AuthUser? user) {
  return _firstNonBlank(<String?>[
        user?.lastName,
        user?.username,
        user?.email,
        user?.mobile,
        user?.phone,
      ]) ??
      'FUNDEX';
}

String? _firstNonBlank(List<String?> candidates) {
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

_Gender _resolveGender(int? sex) {
  return switch (sex) {
    1 => _Gender.male,
    2 => _Gender.female,
    _ => _Gender.unknown,
  };
}

enum _Gender { male, female, unknown }
