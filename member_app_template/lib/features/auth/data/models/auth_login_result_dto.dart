import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_session_dto.dart';
import 'auth_user_dto.dart';

part 'auth_login_result_dto.freezed.dart';

@freezed
class AuthLoginResultDto with _$AuthLoginResultDto {
  const factory AuthLoginResultDto({
    required AuthSessionDto session,
    AuthUserDto? user,
  }) = _AuthLoginResultDto;
}
