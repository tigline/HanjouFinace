// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion_comment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscussionQuoteDto _$DiscussionQuoteDtoFromJson(Map<String, dynamic> json) {
  return _DiscussionQuoteDto.fromJson(json);
}

/// @nodoc
mixin _$DiscussionQuoteDto {
  @JsonKey(fromJson: _toNullableInt)
  int? get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createTime => throw _privateConstructorUsedError;

  /// Serializes this DiscussionQuoteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscussionQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscussionQuoteDtoCopyWith<DiscussionQuoteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionQuoteDtoCopyWith<$Res> {
  factory $DiscussionQuoteDtoCopyWith(
    DiscussionQuoteDto value,
    $Res Function(DiscussionQuoteDto) then,
  ) = _$DiscussionQuoteDtoCopyWithImpl<$Res, DiscussionQuoteDto>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _toNullableInt) int? id,
    String username,
    String content,
    String createTime,
  });
}

/// @nodoc
class _$DiscussionQuoteDtoCopyWithImpl<$Res, $Val extends DiscussionQuoteDto>
    implements $DiscussionQuoteDtoCopyWith<$Res> {
  _$DiscussionQuoteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscussionQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? username = null,
    Object? content = null,
    Object? createTime = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscussionQuoteDtoImplCopyWith<$Res>
    implements $DiscussionQuoteDtoCopyWith<$Res> {
  factory _$$DiscussionQuoteDtoImplCopyWith(
    _$DiscussionQuoteDtoImpl value,
    $Res Function(_$DiscussionQuoteDtoImpl) then,
  ) = __$$DiscussionQuoteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _toNullableInt) int? id,
    String username,
    String content,
    String createTime,
  });
}

/// @nodoc
class __$$DiscussionQuoteDtoImplCopyWithImpl<$Res>
    extends _$DiscussionQuoteDtoCopyWithImpl<$Res, _$DiscussionQuoteDtoImpl>
    implements _$$DiscussionQuoteDtoImplCopyWith<$Res> {
  __$$DiscussionQuoteDtoImplCopyWithImpl(
    _$DiscussionQuoteDtoImpl _value,
    $Res Function(_$DiscussionQuoteDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscussionQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? username = null,
    Object? content = null,
    Object? createTime = null,
  }) {
    return _then(
      _$DiscussionQuoteDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscussionQuoteDtoImpl implements _DiscussionQuoteDto {
  const _$DiscussionQuoteDtoImpl({
    @JsonKey(fromJson: _toNullableInt) this.id,
    this.username = '',
    this.content = '',
    this.createTime = '',
  });

  factory _$DiscussionQuoteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscussionQuoteDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _toNullableInt)
  final int? id;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String createTime;

  @override
  String toString() {
    return 'DiscussionQuoteDto(id: $id, username: $username, content: $content, createTime: $createTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscussionQuoteDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, content, createTime);

  /// Create a copy of DiscussionQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscussionQuoteDtoImplCopyWith<_$DiscussionQuoteDtoImpl> get copyWith =>
      __$$DiscussionQuoteDtoImplCopyWithImpl<_$DiscussionQuoteDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscussionQuoteDtoImplToJson(this);
  }
}

abstract class _DiscussionQuoteDto implements DiscussionQuoteDto {
  const factory _DiscussionQuoteDto({
    @JsonKey(fromJson: _toNullableInt) final int? id,
    final String username,
    final String content,
    final String createTime,
  }) = _$DiscussionQuoteDtoImpl;

  factory _DiscussionQuoteDto.fromJson(Map<String, dynamic> json) =
      _$DiscussionQuoteDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _toNullableInt)
  int? get id;
  @override
  String get username;
  @override
  String get content;
  @override
  String get createTime;

  /// Create a copy of DiscussionQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscussionQuoteDtoImplCopyWith<_$DiscussionQuoteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiscussionCommentDto _$DiscussionCommentDtoFromJson(Map<String, dynamic> json) {
  return _DiscussionCommentDto.fromJson(json);
}

/// @nodoc
mixin _$DiscussionCommentDto {
  @JsonKey(fromJson: _toNullableInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toNullableInt)
  int? get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toNullableInt)
  int? get projectId => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _quoteFromJson)
  DiscussionQuoteDto? get quote => throw _privateConstructorUsedError;

  /// Serializes this DiscussionCommentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscussionCommentDtoCopyWith<DiscussionCommentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionCommentDtoCopyWith<$Res> {
  factory $DiscussionCommentDtoCopyWith(
    DiscussionCommentDto value,
    $Res Function(DiscussionCommentDto) then,
  ) = _$DiscussionCommentDtoCopyWithImpl<$Res, DiscussionCommentDto>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _toNullableInt) int? id,
    @JsonKey(fromJson: _toNullableInt) int? userId,
    String username,
    String content,
    String createTime,
    @JsonKey(fromJson: _toNullableInt) int? projectId,
    String projectName,
    @JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? quote,
  });

  $DiscussionQuoteDtoCopyWith<$Res>? get quote;
}

/// @nodoc
class _$DiscussionCommentDtoCopyWithImpl<
  $Res,
  $Val extends DiscussionCommentDto
>
    implements $DiscussionCommentDtoCopyWith<$Res> {
  _$DiscussionCommentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? username = null,
    Object? content = null,
    Object? createTime = null,
    Object? projectId = freezed,
    Object? projectName = null,
    Object? quote = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as int?,
            projectName: null == projectName
                ? _value.projectName
                : projectName // ignore: cast_nullable_to_non_nullable
                      as String,
            quote: freezed == quote
                ? _value.quote
                : quote // ignore: cast_nullable_to_non_nullable
                      as DiscussionQuoteDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscussionQuoteDtoCopyWith<$Res>? get quote {
    if (_value.quote == null) {
      return null;
    }

    return $DiscussionQuoteDtoCopyWith<$Res>(_value.quote!, (value) {
      return _then(_value.copyWith(quote: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscussionCommentDtoImplCopyWith<$Res>
    implements $DiscussionCommentDtoCopyWith<$Res> {
  factory _$$DiscussionCommentDtoImplCopyWith(
    _$DiscussionCommentDtoImpl value,
    $Res Function(_$DiscussionCommentDtoImpl) then,
  ) = __$$DiscussionCommentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _toNullableInt) int? id,
    @JsonKey(fromJson: _toNullableInt) int? userId,
    String username,
    String content,
    String createTime,
    @JsonKey(fromJson: _toNullableInt) int? projectId,
    String projectName,
    @JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? quote,
  });

  @override
  $DiscussionQuoteDtoCopyWith<$Res>? get quote;
}

/// @nodoc
class __$$DiscussionCommentDtoImplCopyWithImpl<$Res>
    extends _$DiscussionCommentDtoCopyWithImpl<$Res, _$DiscussionCommentDtoImpl>
    implements _$$DiscussionCommentDtoImplCopyWith<$Res> {
  __$$DiscussionCommentDtoImplCopyWithImpl(
    _$DiscussionCommentDtoImpl _value,
    $Res Function(_$DiscussionCommentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? username = null,
    Object? content = null,
    Object? createTime = null,
    Object? projectId = freezed,
    Object? projectName = null,
    Object? quote = freezed,
  }) {
    return _then(
      _$DiscussionCommentDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: freezed == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as int?,
        projectName: null == projectName
            ? _value.projectName
            : projectName // ignore: cast_nullable_to_non_nullable
                  as String,
        quote: freezed == quote
            ? _value.quote
            : quote // ignore: cast_nullable_to_non_nullable
                  as DiscussionQuoteDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscussionCommentDtoImpl implements _DiscussionCommentDto {
  const _$DiscussionCommentDtoImpl({
    @JsonKey(fromJson: _toNullableInt) this.id,
    @JsonKey(fromJson: _toNullableInt) this.userId,
    this.username = '',
    this.content = '',
    this.createTime = '',
    @JsonKey(fromJson: _toNullableInt) this.projectId,
    this.projectName = '',
    @JsonKey(fromJson: _quoteFromJson) this.quote,
  });

  factory _$DiscussionCommentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscussionCommentDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _toNullableInt)
  final int? id;
  @override
  @JsonKey(fromJson: _toNullableInt)
  final int? userId;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String createTime;
  @override
  @JsonKey(fromJson: _toNullableInt)
  final int? projectId;
  @override
  @JsonKey()
  final String projectName;
  @override
  @JsonKey(fromJson: _quoteFromJson)
  final DiscussionQuoteDto? quote;

  @override
  String toString() {
    return 'DiscussionCommentDto(id: $id, userId: $userId, username: $username, content: $content, createTime: $createTime, projectId: $projectId, projectName: $projectName, quote: $quote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscussionCommentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.quote, quote) || other.quote == quote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    username,
    content,
    createTime,
    projectId,
    projectName,
    quote,
  );

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscussionCommentDtoImplCopyWith<_$DiscussionCommentDtoImpl>
  get copyWith =>
      __$$DiscussionCommentDtoImplCopyWithImpl<_$DiscussionCommentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscussionCommentDtoImplToJson(this);
  }
}

abstract class _DiscussionCommentDto implements DiscussionCommentDto {
  const factory _DiscussionCommentDto({
    @JsonKey(fromJson: _toNullableInt) final int? id,
    @JsonKey(fromJson: _toNullableInt) final int? userId,
    final String username,
    final String content,
    final String createTime,
    @JsonKey(fromJson: _toNullableInt) final int? projectId,
    final String projectName,
    @JsonKey(fromJson: _quoteFromJson) final DiscussionQuoteDto? quote,
  }) = _$DiscussionCommentDtoImpl;

  factory _DiscussionCommentDto.fromJson(Map<String, dynamic> json) =
      _$DiscussionCommentDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _toNullableInt)
  int? get id;
  @override
  @JsonKey(fromJson: _toNullableInt)
  int? get userId;
  @override
  String get username;
  @override
  String get content;
  @override
  String get createTime;
  @override
  @JsonKey(fromJson: _toNullableInt)
  int? get projectId;
  @override
  String get projectName;
  @override
  @JsonKey(fromJson: _quoteFromJson)
  DiscussionQuoteDto? get quote;

  /// Create a copy of DiscussionCommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscussionCommentDtoImplCopyWith<_$DiscussionCommentDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
