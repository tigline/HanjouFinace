// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_login_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthLoginResultDto {
  AuthSessionDto get session => throw _privateConstructorUsedError;
  AuthUserDto? get user => throw _privateConstructorUsedError;

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthLoginResultDtoCopyWith<AuthLoginResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthLoginResultDtoCopyWith<$Res> {
  factory $AuthLoginResultDtoCopyWith(
    AuthLoginResultDto value,
    $Res Function(AuthLoginResultDto) then,
  ) = _$AuthLoginResultDtoCopyWithImpl<$Res, AuthLoginResultDto>;
  @useResult
  $Res call({AuthSessionDto session, AuthUserDto? user});

  $AuthSessionDtoCopyWith<$Res> get session;
  $AuthUserDtoCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthLoginResultDtoCopyWithImpl<$Res, $Val extends AuthLoginResultDto>
    implements $AuthLoginResultDtoCopyWith<$Res> {
  _$AuthLoginResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? user = freezed}) {
    return _then(
      _value.copyWith(
            session: null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as AuthSessionDto,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as AuthUserDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthSessionDtoCopyWith<$Res> get session {
    return $AuthSessionDtoCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $AuthUserDtoCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthLoginResultDtoImplCopyWith<$Res>
    implements $AuthLoginResultDtoCopyWith<$Res> {
  factory _$$AuthLoginResultDtoImplCopyWith(
    _$AuthLoginResultDtoImpl value,
    $Res Function(_$AuthLoginResultDtoImpl) then,
  ) = __$$AuthLoginResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthSessionDto session, AuthUserDto? user});

  @override
  $AuthSessionDtoCopyWith<$Res> get session;
  @override
  $AuthUserDtoCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthLoginResultDtoImplCopyWithImpl<$Res>
    extends _$AuthLoginResultDtoCopyWithImpl<$Res, _$AuthLoginResultDtoImpl>
    implements _$$AuthLoginResultDtoImplCopyWith<$Res> {
  __$$AuthLoginResultDtoImplCopyWithImpl(
    _$AuthLoginResultDtoImpl _value,
    $Res Function(_$AuthLoginResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null, Object? user = freezed}) {
    return _then(
      _$AuthLoginResultDtoImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as AuthSessionDto,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as AuthUserDto?,
      ),
    );
  }
}

/// @nodoc

class _$AuthLoginResultDtoImpl implements _AuthLoginResultDto {
  const _$AuthLoginResultDtoImpl({required this.session, this.user});

  @override
  final AuthSessionDto session;
  @override
  final AuthUserDto? user;

  @override
  String toString() {
    return 'AuthLoginResultDto(session: $session, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoginResultDtoImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session, user);

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoginResultDtoImplCopyWith<_$AuthLoginResultDtoImpl> get copyWith =>
      __$$AuthLoginResultDtoImplCopyWithImpl<_$AuthLoginResultDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthLoginResultDto implements AuthLoginResultDto {
  const factory _AuthLoginResultDto({
    required final AuthSessionDto session,
    final AuthUserDto? user,
  }) = _$AuthLoginResultDtoImpl;

  @override
  AuthSessionDto get session;
  @override
  AuthUserDto? get user;

  /// Create a copy of AuthLoginResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLoginResultDtoImplCopyWith<_$AuthLoginResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
