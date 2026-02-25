// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) {
  return _AuthUserDto.fromJson(json);
}

/// @nodoc
mixin _$AuthUserDto {
  String get username => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get mobile => throw _privateConstructorUsedError;
  int? get memberLevel => throw _privateConstructorUsedError;
  String? get intlTelCode => throw _privateConstructorUsedError;

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserDtoCopyWith<AuthUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserDtoCopyWith<$Res> {
  factory $AuthUserDtoCopyWith(
    AuthUserDto value,
    $Res Function(AuthUserDto) then,
  ) = _$AuthUserDtoCopyWithImpl<$Res, AuthUserDto>;
  @useResult
  $Res call({
    String username,
    int? userId,
    String? email,
    String? mobile,
    int? memberLevel,
    String? intlTelCode,
  });
}

/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res, $Val extends AuthUserDto>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? mobile = freezed,
    Object? memberLevel = freezed,
    Object? intlTelCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            mobile: freezed == mobile
                ? _value.mobile
                : mobile // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberLevel: freezed == memberLevel
                ? _value.memberLevel
                : memberLevel // ignore: cast_nullable_to_non_nullable
                      as int?,
            intlTelCode: freezed == intlTelCode
                ? _value.intlTelCode
                : intlTelCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthUserDtoImplCopyWith<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  factory _$$AuthUserDtoImplCopyWith(
    _$AuthUserDtoImpl value,
    $Res Function(_$AuthUserDtoImpl) then,
  ) = __$$AuthUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    int? userId,
    String? email,
    String? mobile,
    int? memberLevel,
    String? intlTelCode,
  });
}

/// @nodoc
class __$$AuthUserDtoImplCopyWithImpl<$Res>
    extends _$AuthUserDtoCopyWithImpl<$Res, _$AuthUserDtoImpl>
    implements _$$AuthUserDtoImplCopyWith<$Res> {
  __$$AuthUserDtoImplCopyWithImpl(
    _$AuthUserDtoImpl _value,
    $Res Function(_$AuthUserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? mobile = freezed,
    Object? memberLevel = freezed,
    Object? intlTelCode = freezed,
  }) {
    return _then(
      _$AuthUserDtoImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        mobile: freezed == mobile
            ? _value.mobile
            : mobile // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberLevel: freezed == memberLevel
            ? _value.memberLevel
            : memberLevel // ignore: cast_nullable_to_non_nullable
                  as int?,
        intlTelCode: freezed == intlTelCode
            ? _value.intlTelCode
            : intlTelCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserDtoImpl extends _AuthUserDto {
  const _$AuthUserDtoImpl({
    required this.username,
    this.userId,
    this.email,
    this.mobile,
    this.memberLevel,
    this.intlTelCode,
  }) : super._();

  factory _$AuthUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserDtoImplFromJson(json);

  @override
  final String username;
  @override
  final int? userId;
  @override
  final String? email;
  @override
  final String? mobile;
  @override
  final int? memberLevel;
  @override
  final String? intlTelCode;

  @override
  String toString() {
    return 'AuthUserDto(username: $username, userId: $userId, email: $email, mobile: $mobile, memberLevel: $memberLevel, intlTelCode: $intlTelCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserDtoImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.memberLevel, memberLevel) ||
                other.memberLevel == memberLevel) &&
            (identical(other.intlTelCode, intlTelCode) ||
                other.intlTelCode == intlTelCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    username,
    userId,
    email,
    mobile,
    memberLevel,
    intlTelCode,
  );

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      __$$AuthUserDtoImplCopyWithImpl<_$AuthUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserDtoImplToJson(this);
  }
}

abstract class _AuthUserDto extends AuthUserDto {
  const factory _AuthUserDto({
    required final String username,
    final int? userId,
    final String? email,
    final String? mobile,
    final int? memberLevel,
    final String? intlTelCode,
  }) = _$AuthUserDtoImpl;
  const _AuthUserDto._() : super._();

  factory _AuthUserDto.fromJson(Map<String, dynamic> json) =
      _$AuthUserDtoImpl.fromJson;

  @override
  String get username;
  @override
  int? get userId;
  @override
  String? get email;
  @override
  String? get mobile;
  @override
  int? get memberLevel;
  @override
  String? get intlTelCode;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
