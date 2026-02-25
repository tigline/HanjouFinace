import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String username,
    int? userId,
    String? email,
    String? mobile,
    int? memberLevel,
    String? intlTelCode,
  }) = _AuthUser;
}
