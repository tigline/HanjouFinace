import 'auth_session_dto.dart';
import 'auth_user_dto.dart';

class AuthLoginResultDto {
  const AuthLoginResultDto({required this.session, this.user});

  final AuthSessionDto session;
  final AuthUserDto? user;
}
