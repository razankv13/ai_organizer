// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud_storage_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CloudStorageConnection {

 String get id; String get userId; CloudStorageProvider get provider; String get accessToken; String? get refreshToken; DateTime? get tokenExpiry; String? get userEmail; String? get userName;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of CloudStorageConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudStorageConnectionCopyWith<CloudStorageConnection> get copyWith => _$CloudStorageConnectionCopyWithImpl<CloudStorageConnection>(this as CloudStorageConnection, _$identity);

  /// Serializes this CloudStorageConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudStorageConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenExpiry, tokenExpiry) || other.tokenExpiry == tokenExpiry)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,provider,accessToken,refreshToken,tokenExpiry,userEmail,userName,createdAt,updatedAt);

@override
String toString() {
  return 'CloudStorageConnection(id: $id, userId: $userId, provider: $provider, accessToken: $accessToken, refreshToken: $refreshToken, tokenExpiry: $tokenExpiry, userEmail: $userEmail, userName: $userName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CloudStorageConnectionCopyWith<$Res>  {
  factory $CloudStorageConnectionCopyWith(CloudStorageConnection value, $Res Function(CloudStorageConnection) _then) = _$CloudStorageConnectionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, CloudStorageProvider provider, String accessToken, String? refreshToken, DateTime? tokenExpiry, String? userEmail, String? userName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$CloudStorageConnectionCopyWithImpl<$Res>
    implements $CloudStorageConnectionCopyWith<$Res> {
  _$CloudStorageConnectionCopyWithImpl(this._self, this._then);

  final CloudStorageConnection _self;
  final $Res Function(CloudStorageConnection) _then;

/// Create a copy of CloudStorageConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? provider = null,Object? accessToken = null,Object? refreshToken = freezed,Object? tokenExpiry = freezed,Object? userEmail = freezed,Object? userName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as CloudStorageProvider,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,tokenExpiry: freezed == tokenExpiry ? _self.tokenExpiry : tokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudStorageConnection].
extension CloudStorageConnectionPatterns on CloudStorageConnection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudStorageConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudStorageConnection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudStorageConnection value)  $default,){
final _that = this;
switch (_that) {
case _CloudStorageConnection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudStorageConnection value)?  $default,){
final _that = this;
switch (_that) {
case _CloudStorageConnection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  CloudStorageProvider provider,  String accessToken,  String? refreshToken,  DateTime? tokenExpiry,  String? userEmail,  String? userName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudStorageConnection() when $default != null:
return $default(_that.id,_that.userId,_that.provider,_that.accessToken,_that.refreshToken,_that.tokenExpiry,_that.userEmail,_that.userName,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  CloudStorageProvider provider,  String accessToken,  String? refreshToken,  DateTime? tokenExpiry,  String? userEmail,  String? userName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CloudStorageConnection():
return $default(_that.id,_that.userId,_that.provider,_that.accessToken,_that.refreshToken,_that.tokenExpiry,_that.userEmail,_that.userName,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  CloudStorageProvider provider,  String accessToken,  String? refreshToken,  DateTime? tokenExpiry,  String? userEmail,  String? userName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CloudStorageConnection() when $default != null:
return $default(_that.id,_that.userId,_that.provider,_that.accessToken,_that.refreshToken,_that.tokenExpiry,_that.userEmail,_that.userName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudStorageConnection implements CloudStorageConnection {
  const _CloudStorageConnection({required this.id, required this.userId, required this.provider, required this.accessToken, this.refreshToken, this.tokenExpiry, this.userEmail, this.userName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _CloudStorageConnection.fromJson(Map<String, dynamic> json) => _$CloudStorageConnectionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  CloudStorageProvider provider;
@override final  String accessToken;
@override final  String? refreshToken;
@override final  DateTime? tokenExpiry;
@override final  String? userEmail;
@override final  String? userName;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of CloudStorageConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudStorageConnectionCopyWith<_CloudStorageConnection> get copyWith => __$CloudStorageConnectionCopyWithImpl<_CloudStorageConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudStorageConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudStorageConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenExpiry, tokenExpiry) || other.tokenExpiry == tokenExpiry)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,provider,accessToken,refreshToken,tokenExpiry,userEmail,userName,createdAt,updatedAt);

@override
String toString() {
  return 'CloudStorageConnection(id: $id, userId: $userId, provider: $provider, accessToken: $accessToken, refreshToken: $refreshToken, tokenExpiry: $tokenExpiry, userEmail: $userEmail, userName: $userName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CloudStorageConnectionCopyWith<$Res> implements $CloudStorageConnectionCopyWith<$Res> {
  factory _$CloudStorageConnectionCopyWith(_CloudStorageConnection value, $Res Function(_CloudStorageConnection) _then) = __$CloudStorageConnectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, CloudStorageProvider provider, String accessToken, String? refreshToken, DateTime? tokenExpiry, String? userEmail, String? userName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$CloudStorageConnectionCopyWithImpl<$Res>
    implements _$CloudStorageConnectionCopyWith<$Res> {
  __$CloudStorageConnectionCopyWithImpl(this._self, this._then);

  final _CloudStorageConnection _self;
  final $Res Function(_CloudStorageConnection) _then;

/// Create a copy of CloudStorageConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? provider = null,Object? accessToken = null,Object? refreshToken = freezed,Object? tokenExpiry = freezed,Object? userEmail = freezed,Object? userName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CloudStorageConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as CloudStorageProvider,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,tokenExpiry: freezed == tokenExpiry ? _self.tokenExpiry : tokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
