// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmailSettings {

 String get id; String get userId; String get uniqueEmail; DateTime get createdAt; DateTime get updatedAt; bool get isEnabled; bool get gmailConnected; String? get gmailEmail; String? get gmailRefreshToken; DateTime? get lastGmailSync; Map<String, dynamic> get preferences;
/// Create a copy of EmailSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailSettingsCopyWith<EmailSettings> get copyWith => _$EmailSettingsCopyWithImpl<EmailSettings>(this as EmailSettings, _$identity);

  /// Serializes this EmailSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uniqueEmail, uniqueEmail) || other.uniqueEmail == uniqueEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.gmailConnected, gmailConnected) || other.gmailConnected == gmailConnected)&&(identical(other.gmailEmail, gmailEmail) || other.gmailEmail == gmailEmail)&&(identical(other.gmailRefreshToken, gmailRefreshToken) || other.gmailRefreshToken == gmailRefreshToken)&&(identical(other.lastGmailSync, lastGmailSync) || other.lastGmailSync == lastGmailSync)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,uniqueEmail,createdAt,updatedAt,isEnabled,gmailConnected,gmailEmail,gmailRefreshToken,lastGmailSync,const DeepCollectionEquality().hash(preferences));

@override
String toString() {
  return 'EmailSettings(id: $id, userId: $userId, uniqueEmail: $uniqueEmail, createdAt: $createdAt, updatedAt: $updatedAt, isEnabled: $isEnabled, gmailConnected: $gmailConnected, gmailEmail: $gmailEmail, gmailRefreshToken: $gmailRefreshToken, lastGmailSync: $lastGmailSync, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $EmailSettingsCopyWith<$Res>  {
  factory $EmailSettingsCopyWith(EmailSettings value, $Res Function(EmailSettings) _then) = _$EmailSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String uniqueEmail, DateTime createdAt, DateTime updatedAt, bool isEnabled, bool gmailConnected, String? gmailEmail, String? gmailRefreshToken, DateTime? lastGmailSync, Map<String, dynamic> preferences
});




}
/// @nodoc
class _$EmailSettingsCopyWithImpl<$Res>
    implements $EmailSettingsCopyWith<$Res> {
  _$EmailSettingsCopyWithImpl(this._self, this._then);

  final EmailSettings _self;
  final $Res Function(EmailSettings) _then;

/// Create a copy of EmailSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? uniqueEmail = null,Object? createdAt = null,Object? updatedAt = null,Object? isEnabled = null,Object? gmailConnected = null,Object? gmailEmail = freezed,Object? gmailRefreshToken = freezed,Object? lastGmailSync = freezed,Object? preferences = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uniqueEmail: null == uniqueEmail ? _self.uniqueEmail : uniqueEmail // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,gmailConnected: null == gmailConnected ? _self.gmailConnected : gmailConnected // ignore: cast_nullable_to_non_nullable
as bool,gmailEmail: freezed == gmailEmail ? _self.gmailEmail : gmailEmail // ignore: cast_nullable_to_non_nullable
as String?,gmailRefreshToken: freezed == gmailRefreshToken ? _self.gmailRefreshToken : gmailRefreshToken // ignore: cast_nullable_to_non_nullable
as String?,lastGmailSync: freezed == lastGmailSync ? _self.lastGmailSync : lastGmailSync // ignore: cast_nullable_to_non_nullable
as DateTime?,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailSettings].
extension EmailSettingsPatterns on EmailSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailSettings value)  $default,){
final _that = this;
switch (_that) {
case _EmailSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailSettings value)?  $default,){
final _that = this;
switch (_that) {
case _EmailSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String uniqueEmail,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  bool gmailConnected,  String? gmailEmail,  String? gmailRefreshToken,  DateTime? lastGmailSync,  Map<String, dynamic> preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailSettings() when $default != null:
return $default(_that.id,_that.userId,_that.uniqueEmail,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.gmailConnected,_that.gmailEmail,_that.gmailRefreshToken,_that.lastGmailSync,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String uniqueEmail,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  bool gmailConnected,  String? gmailEmail,  String? gmailRefreshToken,  DateTime? lastGmailSync,  Map<String, dynamic> preferences)  $default,) {final _that = this;
switch (_that) {
case _EmailSettings():
return $default(_that.id,_that.userId,_that.uniqueEmail,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.gmailConnected,_that.gmailEmail,_that.gmailRefreshToken,_that.lastGmailSync,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String uniqueEmail,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  bool gmailConnected,  String? gmailEmail,  String? gmailRefreshToken,  DateTime? lastGmailSync,  Map<String, dynamic> preferences)?  $default,) {final _that = this;
switch (_that) {
case _EmailSettings() when $default != null:
return $default(_that.id,_that.userId,_that.uniqueEmail,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.gmailConnected,_that.gmailEmail,_that.gmailRefreshToken,_that.lastGmailSync,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmailSettings implements EmailSettings {
  const _EmailSettings({required this.id, required this.userId, required this.uniqueEmail, required this.createdAt, required this.updatedAt, this.isEnabled = true, this.gmailConnected = false, this.gmailEmail, this.gmailRefreshToken, this.lastGmailSync, final  Map<String, dynamic> preferences = const {}}): _preferences = preferences;
  factory _EmailSettings.fromJson(Map<String, dynamic> json) => _$EmailSettingsFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String uniqueEmail;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  bool gmailConnected;
@override final  String? gmailEmail;
@override final  String? gmailRefreshToken;
@override final  DateTime? lastGmailSync;
 final  Map<String, dynamic> _preferences;
@override@JsonKey() Map<String, dynamic> get preferences {
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preferences);
}


/// Create a copy of EmailSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailSettingsCopyWith<_EmailSettings> get copyWith => __$EmailSettingsCopyWithImpl<_EmailSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmailSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.uniqueEmail, uniqueEmail) || other.uniqueEmail == uniqueEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.gmailConnected, gmailConnected) || other.gmailConnected == gmailConnected)&&(identical(other.gmailEmail, gmailEmail) || other.gmailEmail == gmailEmail)&&(identical(other.gmailRefreshToken, gmailRefreshToken) || other.gmailRefreshToken == gmailRefreshToken)&&(identical(other.lastGmailSync, lastGmailSync) || other.lastGmailSync == lastGmailSync)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,uniqueEmail,createdAt,updatedAt,isEnabled,gmailConnected,gmailEmail,gmailRefreshToken,lastGmailSync,const DeepCollectionEquality().hash(_preferences));

@override
String toString() {
  return 'EmailSettings(id: $id, userId: $userId, uniqueEmail: $uniqueEmail, createdAt: $createdAt, updatedAt: $updatedAt, isEnabled: $isEnabled, gmailConnected: $gmailConnected, gmailEmail: $gmailEmail, gmailRefreshToken: $gmailRefreshToken, lastGmailSync: $lastGmailSync, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$EmailSettingsCopyWith<$Res> implements $EmailSettingsCopyWith<$Res> {
  factory _$EmailSettingsCopyWith(_EmailSettings value, $Res Function(_EmailSettings) _then) = __$EmailSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String uniqueEmail, DateTime createdAt, DateTime updatedAt, bool isEnabled, bool gmailConnected, String? gmailEmail, String? gmailRefreshToken, DateTime? lastGmailSync, Map<String, dynamic> preferences
});




}
/// @nodoc
class __$EmailSettingsCopyWithImpl<$Res>
    implements _$EmailSettingsCopyWith<$Res> {
  __$EmailSettingsCopyWithImpl(this._self, this._then);

  final _EmailSettings _self;
  final $Res Function(_EmailSettings) _then;

/// Create a copy of EmailSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? uniqueEmail = null,Object? createdAt = null,Object? updatedAt = null,Object? isEnabled = null,Object? gmailConnected = null,Object? gmailEmail = freezed,Object? gmailRefreshToken = freezed,Object? lastGmailSync = freezed,Object? preferences = null,}) {
  return _then(_EmailSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,uniqueEmail: null == uniqueEmail ? _self.uniqueEmail : uniqueEmail // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,gmailConnected: null == gmailConnected ? _self.gmailConnected : gmailConnected // ignore: cast_nullable_to_non_nullable
as bool,gmailEmail: freezed == gmailEmail ? _self.gmailEmail : gmailEmail // ignore: cast_nullable_to_non_nullable
as String?,gmailRefreshToken: freezed == gmailRefreshToken ? _self.gmailRefreshToken : gmailRefreshToken // ignore: cast_nullable_to_non_nullable
as String?,lastGmailSync: freezed == lastGmailSync ? _self.lastGmailSync : lastGmailSync // ignore: cast_nullable_to_non_nullable
as DateTime?,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
