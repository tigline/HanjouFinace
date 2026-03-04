import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/home/presentation/support/home_display_name_resolver.dart';

void main() {
  group('resolveHomeDisplayName', () {
    test('uses lastName with さん in Japanese locale', () {
      final user = AuthUser(
        username: 'aaron@example.com',
        lastName: '田中',
        sex: 1,
      );

      final result = resolveHomeDisplayName(
        locale: const Locale('ja'),
        user: user,
      );

      expect(result, '田中さん');
    });

    test('uses male honorific in Chinese locale', () {
      final user = AuthUser(
        username: 'aaron@example.com',
        lastName: '田中',
        sex: 1,
      );

      final result = resolveHomeDisplayName(
        locale: const Locale('zh'),
        user: user,
      );

      expect(result, '田中先生');
    });

    test('uses female honorific in Chinese locale', () {
      final user = AuthUser(username: 'amy@example.com', lastName: '王', sex: 2);

      final result = resolveHomeDisplayName(
        locale: const Locale('zh'),
        user: user,
      );

      expect(result, '王女士');
    });

    test('uses english last name with english honorific', () {
      final user = AuthUser(
        username: 'aaron@example.com',
        lastName: '田中',
        lastNameEn: 'Tanaka',
        sex: 1,
      );

      final result = resolveHomeDisplayName(
        locale: const Locale('en'),
        user: user,
      );

      expect(result, 'Mr. Tanaka');
    });

    test('falls back to plain name when sex is unknown in Chinese locale', () {
      final user = AuthUser(username: 'aaron@example.com', lastName: '田中');

      final result = resolveHomeDisplayName(
        locale: const Locale('zh'),
        user: user,
      );

      expect(result, '田中');
    });
  });
}
