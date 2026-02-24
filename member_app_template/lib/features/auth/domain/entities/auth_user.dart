class AuthUser {
  const AuthUser({
    required this.username,
    this.userId,
    this.email,
    this.mobile,
    this.memberLevel,
    this.intlTelCode,
  });

  final String username;
  final int? userId;
  final String? email;
  final String? mobile;
  final int? memberLevel;
  final String? intlTelCode;
}
