// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attachment {

 String get id; String? get noteId; String get fileName; String get filePath; AttachmentType get type; int get fileSize; DateTime get createdAt; String? get mimeType; String? get thumbnailPath; Map<String, dynamic>? get metadata;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,fileName,filePath,type,fileSize,createdAt,mimeType,thumbnailPath,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'Attachment(id: $id, noteId: $noteId, fileName: $fileName, filePath: $filePath, type: $type, fileSize: $fileSize, createdAt: $createdAt, mimeType: $mimeType, thumbnailPath: $thumbnailPath, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 String id, String? noteId, String fileName, String filePath, AttachmentType type, int fileSize, DateTime createdAt, String? mimeType, String? thumbnailPath, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noteId = freezed,Object? fileName = null,Object? filePath = null,Object? type = null,Object? fileSize = null,Object? createdAt = null,Object? mimeType = freezed,Object? thumbnailPath = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AttachmentType,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? noteId,  String fileName,  String filePath,  AttachmentType type,  int fileSize,  DateTime createdAt,  String? mimeType,  String? thumbnailPath,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.noteId,_that.fileName,_that.filePath,_that.type,_that.fileSize,_that.createdAt,_that.mimeType,_that.thumbnailPath,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? noteId,  String fileName,  String filePath,  AttachmentType type,  int fileSize,  DateTime createdAt,  String? mimeType,  String? thumbnailPath,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.id,_that.noteId,_that.fileName,_that.filePath,_that.type,_that.fileSize,_that.createdAt,_that.mimeType,_that.thumbnailPath,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? noteId,  String fileName,  String filePath,  AttachmentType type,  int fileSize,  DateTime createdAt,  String? mimeType,  String? thumbnailPath,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.noteId,_that.fileName,_that.filePath,_that.type,_that.fileSize,_that.createdAt,_that.mimeType,_that.thumbnailPath,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachment extends Attachment {
  const _Attachment({required this.id, this.noteId, required this.fileName, required this.filePath, required this.type, required this.fileSize, required this.createdAt, this.mimeType, this.thumbnailPath, final  Map<String, dynamic>? metadata}): _metadata = metadata,super._();
  factory _Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

@override final  String id;
@override final  String? noteId;
@override final  String fileName;
@override final  String filePath;
@override final  AttachmentType type;
@override final  int fileSize;
@override final  DateTime createdAt;
@override final  String? mimeType;
@override final  String? thumbnailPath;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,fileName,filePath,type,fileSize,createdAt,mimeType,thumbnailPath,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'Attachment(id: $id, noteId: $noteId, fileName: $fileName, filePath: $filePath, type: $type, fileSize: $fileSize, createdAt: $createdAt, mimeType: $mimeType, thumbnailPath: $thumbnailPath, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String? noteId, String fileName, String filePath, AttachmentType type, int fileSize, DateTime createdAt, String? mimeType, String? thumbnailPath, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noteId = freezed,Object? fileName = null,Object? filePath = null,Object? type = null,Object? fileSize = null,Object? createdAt = null,Object? mimeType = freezed,Object? thumbnailPath = freezed,Object? metadata = freezed,}) {
  return _then(_Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AttachmentType,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
