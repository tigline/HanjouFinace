export 'package:company_api_runtime/company_api_runtime.dart'
    show AuthSessionDto;

import 'package:company_api_runtime/company_api_runtime.dart'
    show AuthSessionDto;

import '../../domain/entities/auth_session.dart';

extension AuthSessionDtoMapper on AuthSessionDto {
  AuthSession toEntity() {
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
