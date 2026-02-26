import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_dto.freezed.dart';
part 'auth_user_dto.g.dart';

@freezed
class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String username,
    String? id,
    int? userId,
    int? memberId,
    String? accountId,
    String? email,
    String? mobile,
    String? phone,
    int? memberLevel,
    String? intlTelCode,
    String? firstName,
    String? lastName,
    String? firstNameEn,
    String? lastNameEn,
    String? katakana,
    double? taxRadio,
    String? expiredTime,
    String? taxcountry,
    String? nationality,
    String? taxOffice,
    int? sex,
    int? liveJp,
    String? birthday,
    String? zipCode,
    String? address,
    Map<String, dynamic>? bank,
    String? registerTime,
    String? checkEmailTime,
    String? baseinfoTime,
    String? checkBaseinfoTime,
    int? status,
    String? frontUrl,
    String? backUrl,
    String? taxpayerNumber,
    int? taxpayerManageStatus,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(_normalizedJson(json));

  static Map<String, dynamic> _normalizedJson(Map<String, dynamic> json) {
    final username =
        _stringOrNull(json['username']) ??
        _stringOrNull(json['usename']) ??
        _stringOrNull(json['email']) ??
        _stringOrNull(json['phone']) ??
        _stringOrNull(json['mobile']) ??
        _stringOrNull(json['accountId']) ??
        _stringOrNull(json['memberId']) ??
        '';
    final phone = _normalizedOptionalString(json['phone']);
    final mobile = _normalizedOptionalString(json['mobile']) ?? phone;
    final normalizedPhone = phone ?? mobile;
    final normalizedUserId =
        _intOrNull(json['userId']) ?? _intOrNull(json['memberId']);
    final normalizedMemberId =
        _intOrNull(json['memberId']) ?? _intOrNull(json['userId']);
    final normalizedEmail =
        _normalizedOptionalString(json['email']) ??
        (_looksLikeEmail(username) ? username.trim() : null);

    return <String, dynamic>{
      'username': username,
      'id': _normalizedOptionalString(json['id']),
      'userId': normalizedUserId,
      'memberId': normalizedMemberId,
      'accountId': _normalizedOptionalString(json['accountId']),
      'email': normalizedEmail,
      'mobile': mobile,
      'phone': normalizedPhone,
      'memberLevel': _intOrNull(json['memberLevel']),
      'intlTelCode': _normalizedOptionalString(json['intlTelCode']),
      'firstName': _normalizedOptionalString(json['firstName']),
      'lastName': _normalizedOptionalString(json['lastName']),
      'firstNameEn': _normalizedOptionalString(json['firstNameEn']),
      'lastNameEn': _normalizedOptionalString(json['lastNameEn']),
      'katakana': _normalizedOptionalString(json['katakana']),
      'taxRadio': _doubleOrNull(json['taxRadio']),
      'expiredTime': _normalizedOptionalString(json['expiredTime']),
      'taxcountry': _normalizedOptionalString(json['taxcountry']),
      'nationality': _normalizedOptionalString(json['nationality']),
      'taxOffice': _normalizedOptionalString(json['taxOffice']),
      'sex': _intOrNull(json['sex']),
      'liveJp': _intOrNull(json['liveJp']),
      'birthday': _normalizedOptionalString(json['birthday']),
      'zipCode': _normalizedOptionalString(json['zipCode']),
      'address': _normalizedOptionalString(json['address']),
      'bank': _mapOrNull(json['bank']),
      'registerTime': _normalizedOptionalString(json['registerTime']),
      'checkEmailTime': _normalizedOptionalString(json['checkEmailTime']),
      'baseinfoTime': _normalizedOptionalString(json['baseinfoTime']),
      'checkBaseinfoTime': _normalizedOptionalString(json['checkBaseinfoTime']),
      'status': _intOrNull(json['status']),
      'frontUrl': _normalizedOptionalString(json['frontUrl']),
      'backUrl': _normalizedOptionalString(json['backUrl']),
      'taxpayerNumber': _normalizedOptionalString(json['taxpayerNumber']),
      'taxpayerManageStatus': _intOrNull(json['taxpayerManageStatus']),
    };
  }

  static AuthUserDto? tryFromLoginPayload(Map<String, dynamic> json) {
    final dto = AuthUserDto.fromJson(json);
    final hasMeaningfulData =
        dto.username.trim().isNotEmpty ||
        dto.userId != null ||
        dto.memberLevel != null;
    if (!hasMeaningfulData) {
      return null;
    }
    return dto;
  }

  static AuthUserDto? tryFromCurrentUserPayload(Map<String, dynamic> json) {
    final dto = AuthUserDto.fromJson(json);
    final hasMeaningfulData =
        (dto.id?.trim().isNotEmpty ?? false) ||
        dto.memberId != null ||
        dto.userId != null ||
        (dto.accountId?.trim().isNotEmpty ?? false) ||
        (dto.email?.trim().isNotEmpty ?? false) ||
        (dto.phone?.trim().isNotEmpty ?? false) ||
        (dto.mobile?.trim().isNotEmpty ?? false);
    if (!hasMeaningfulData) {
      return null;
    }
    return dto;
  }

  AuthUser toEntity() {
    return AuthUser(
      username: username,
      id: id,
      userId: userId,
      memberId: memberId,
      accountId: accountId,
      email: email,
      mobile: mobile,
      phone: phone,
      memberLevel: memberLevel,
      intlTelCode: intlTelCode,
      firstName: firstName,
      lastName: lastName,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      katakana: katakana,
      taxRadio: taxRadio,
      expiredTime: expiredTime,
      taxcountry: taxcountry,
      nationality: nationality,
      taxOffice: taxOffice,
      sex: sex,
      liveJp: liveJp,
      birthday: birthday,
      zipCode: zipCode,
      address: address,
      bank: bank == null ? null : Map<String, dynamic>.from(bank!),
      registerTime: registerTime,
      checkEmailTime: checkEmailTime,
      baseinfoTime: baseinfoTime,
      checkBaseinfoTime: checkBaseinfoTime,
      status: status,
      frontUrl: frontUrl,
      backUrl: backUrl,
      taxpayerNumber: taxpayerNumber,
      taxpayerManageStatus: taxpayerManageStatus,
    );
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString();
    return text.trim().isEmpty ? null : text;
  }

  static String? _normalizedOptionalString(Object? value) {
    final text = _stringOrNull(value);
    if (text == null) {
      return null;
    }
    return text.trim();
  }

  static int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }

  static double? _doubleOrNull(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value == null) {
      return null;
    }
    return double.tryParse(value.toString());
  }

  static Map<String, dynamic>? _mapOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static bool _looksLikeEmail(String value) {
    return value.contains('@') && value.contains('.');
  }
}
