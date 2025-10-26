// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedNote {

 String get id; String get noteId; String get ownerId; String get sharedWithEmail; String? get sharedWithUserId; SharePermission get permission; String get shareToken; DateTime get createdAt; DateTime get updatedAt; DateTime? get expiresAt; bool get isActive;
/// Create a copy of SharedNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedNoteCopyWith<SharedNote> get copyWith => _$SharedNoteCopyWithImpl<SharedNote>(this as SharedNote, _$identity);

  /// Serializes this SharedNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedNote&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWithEmail, sharedWithEmail) || other.sharedWithEmail == sharedWithEmail)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,ownerId,sharedWithEmail,sharedWithUserId,permission,shareToken,createdAt,updatedAt,expiresAt,isActive);

@override
String toString() {
  return 'SharedNote(id: $id, noteId: $noteId, ownerId: $ownerId, sharedWithEmail: $sharedWithEmail, sharedWithUserId: $sharedWithUserId, permission: $permission, shareToken: $shareToken, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $SharedNoteCopyWith<$Res>  {
  factory $SharedNoteCopyWith(SharedNote value, $Res Function(SharedNote) _then) = _$SharedNoteCopyWithImpl;
@useResult
$Res call({
 String id, String noteId, String ownerId, String sharedWithEmail, String? sharedWithUserId, SharePermission permission, String shareToken, DateTime createdAt, DateTime updatedAt, DateTime? expiresAt, bool isActive
});




}
/// @nodoc
class _$SharedNoteCopyWithImpl<$Res>
    implements $SharedNoteCopyWith<$Res> {
  _$SharedNoteCopyWithImpl(this._self, this._then);

  final SharedNote _self;
  final $Res Function(SharedNote) _then;

/// Create a copy of SharedNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noteId = null,Object? ownerId = null,Object? sharedWithEmail = null,Object? sharedWithUserId = freezed,Object? permission = null,Object? shareToken = null,Object? createdAt = null,Object? updatedAt = null,Object? expiresAt = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,sharedWithEmail: null == sharedWithEmail ? _self.sharedWithEmail : sharedWithEmail // ignore: cast_nullable_to_non_nullable
as String,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as SharePermission,shareToken: null == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedNote].
extension SharedNotePatterns on SharedNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedNote value)  $default,){
final _that = this;
switch (_that) {
case _SharedNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedNote value)?  $default,){
final _that = this;
switch (_that) {
case _SharedNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noteId,  String ownerId,  String sharedWithEmail,  String? sharedWithUserId,  SharePermission permission,  String shareToken,  DateTime createdAt,  DateTime updatedAt,  DateTime? expiresAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedNote() when $default != null:
return $default(_that.id,_that.noteId,_that.ownerId,_that.sharedWithEmail,_that.sharedWithUserId,_that.permission,_that.shareToken,_that.createdAt,_that.updatedAt,_that.expiresAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noteId,  String ownerId,  String sharedWithEmail,  String? sharedWithUserId,  SharePermission permission,  String shareToken,  DateTime createdAt,  DateTime updatedAt,  DateTime? expiresAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _SharedNote():
return $default(_that.id,_that.noteId,_that.ownerId,_that.sharedWithEmail,_that.sharedWithUserId,_that.permission,_that.shareToken,_that.createdAt,_that.updatedAt,_that.expiresAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noteId,  String ownerId,  String sharedWithEmail,  String? sharedWithUserId,  SharePermission permission,  String shareToken,  DateTime createdAt,  DateTime updatedAt,  DateTime? expiresAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _SharedNote() when $default != null:
return $default(_that.id,_that.noteId,_that.ownerId,_that.sharedWithEmail,_that.sharedWithUserId,_that.permission,_that.shareToken,_that.createdAt,_that.updatedAt,_that.expiresAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedNote extends SharedNote {
  const _SharedNote({required this.id, required this.noteId, required this.ownerId, required this.sharedWithEmail, this.sharedWithUserId, required this.permission, required this.shareToken, required this.createdAt, required this.updatedAt, this.expiresAt, this.isActive = true}): super._();
  factory _SharedNote.fromJson(Map<String, dynamic> json) => _$SharedNoteFromJson(json);

@override final  String id;
@override final  String noteId;
@override final  String ownerId;
@override final  String sharedWithEmail;
@override final  String? sharedWithUserId;
@override final  SharePermission permission;
@override final  String shareToken;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? expiresAt;
@override@JsonKey() final  bool isActive;

/// Create a copy of SharedNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedNoteCopyWith<_SharedNote> get copyWith => __$SharedNoteCopyWithImpl<_SharedNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedNote&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.sharedWithEmail, sharedWithEmail) || other.sharedWithEmail == sharedWithEmail)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,ownerId,sharedWithEmail,sharedWithUserId,permission,shareToken,createdAt,updatedAt,expiresAt,isActive);

@override
String toString() {
  return 'SharedNote(id: $id, noteId: $noteId, ownerId: $ownerId, sharedWithEmail: $sharedWithEmail, sharedWithUserId: $sharedWithUserId, permission: $permission, shareToken: $shareToken, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$SharedNoteCopyWith<$Res> implements $SharedNoteCopyWith<$Res> {
  factory _$SharedNoteCopyWith(_SharedNote value, $Res Function(_SharedNote) _then) = __$SharedNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String noteId, String ownerId, String sharedWithEmail, String? sharedWithUserId, SharePermission permission, String shareToken, DateTime createdAt, DateTime updatedAt, DateTime? expiresAt, bool isActive
});




}
/// @nodoc
class __$SharedNoteCopyWithImpl<$Res>
    implements _$SharedNoteCopyWith<$Res> {
  __$SharedNoteCopyWithImpl(this._self, this._then);

  final _SharedNote _self;
  final $Res Function(_SharedNote) _then;

/// Create a copy of SharedNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noteId = null,Object? ownerId = null,Object? sharedWithEmail = null,Object? sharedWithUserId = freezed,Object? permission = null,Object? shareToken = null,Object? createdAt = null,Object? updatedAt = null,Object? expiresAt = freezed,Object? isActive = null,}) {
  return _then(_SharedNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,sharedWithEmail: null == sharedWithEmail ? _self.sharedWithEmail : sharedWithEmail // ignore: cast_nullable_to_non_nullable
as String,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as SharePermission,shareToken: null == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
