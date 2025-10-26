// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Note {

 String get id; String get title; String get content; DateTime get createdAt; DateTime get updatedAt; List<String> get tags; List<String> get attachments; bool get isPinned; bool get isArchived; bool get isFavorite; String? get folderId; String? get color;// For offline-first sync - not serialized
 bool? get isLocal;
/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCopyWith<Note> get copyWith => _$NoteCopyWithImpl<Note>(this as Note, _$identity);

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Note&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.color, color) || other.color == color)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt,updatedAt,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(attachments),isPinned,isArchived,isFavorite,folderId,color,isLocal);

@override
String toString() {
  return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, tags: $tags, attachments: $attachments, isPinned: $isPinned, isArchived: $isArchived, isFavorite: $isFavorite, folderId: $folderId, color: $color, isLocal: $isLocal)';
}


}

/// @nodoc
abstract mixin class $NoteCopyWith<$Res>  {
  factory $NoteCopyWith(Note value, $Res Function(Note) _then) = _$NoteCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, DateTime createdAt, DateTime updatedAt, List<String> tags, List<String> attachments, bool isPinned, bool isArchived, bool isFavorite, String? folderId, String? color, bool? isLocal
});




}
/// @nodoc
class _$NoteCopyWithImpl<$Res>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._self, this._then);

  final Note _self;
  final $Res Function(Note) _then;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? tags = null,Object? attachments = null,Object? isPinned = null,Object? isArchived = null,Object? isFavorite = null,Object? folderId = freezed,Object? color = freezed,Object? isLocal = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isLocal: freezed == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Note].
extension NotePatterns on Note {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Note value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Note() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Note value)  $default,){
final _that = this;
switch (_that) {
case _Note():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Note value)?  $default,){
final _that = this;
switch (_that) {
case _Note() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  DateTime createdAt,  DateTime updatedAt,  List<String> tags,  List<String> attachments,  bool isPinned,  bool isArchived,  bool isFavorite,  String? folderId,  String? color,  bool? isLocal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Note() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.updatedAt,_that.tags,_that.attachments,_that.isPinned,_that.isArchived,_that.isFavorite,_that.folderId,_that.color,_that.isLocal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  DateTime createdAt,  DateTime updatedAt,  List<String> tags,  List<String> attachments,  bool isPinned,  bool isArchived,  bool isFavorite,  String? folderId,  String? color,  bool? isLocal)  $default,) {final _that = this;
switch (_that) {
case _Note():
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.updatedAt,_that.tags,_that.attachments,_that.isPinned,_that.isArchived,_that.isFavorite,_that.folderId,_that.color,_that.isLocal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  DateTime createdAt,  DateTime updatedAt,  List<String> tags,  List<String> attachments,  bool isPinned,  bool isArchived,  bool isFavorite,  String? folderId,  String? color,  bool? isLocal)?  $default,) {final _that = this;
switch (_that) {
case _Note() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.createdAt,_that.updatedAt,_that.tags,_that.attachments,_that.isPinned,_that.isArchived,_that.isFavorite,_that.folderId,_that.color,_that.isLocal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Note extends Note {
  const _Note({required this.id, required this.title, required this.content, required this.createdAt, required this.updatedAt, final  List<String> tags = const [], final  List<String> attachments = const [], this.isPinned = false, this.isArchived = false, this.isFavorite = false, this.folderId, this.color, this.isLocal}): _tags = tags,_attachments = attachments,super._();
  factory _Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

@override final  String id;
@override final  String title;
@override final  String content;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _attachments;
@override@JsonKey() List<String> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isArchived;
@override@JsonKey() final  bool isFavorite;
@override final  String? folderId;
@override final  String? color;
// For offline-first sync - not serialized
@override final  bool? isLocal;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCopyWith<_Note> get copyWith => __$NoteCopyWithImpl<_Note>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Note&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.color, color) || other.color == color)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,createdAt,updatedAt,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_attachments),isPinned,isArchived,isFavorite,folderId,color,isLocal);

@override
String toString() {
  return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, tags: $tags, attachments: $attachments, isPinned: $isPinned, isArchived: $isArchived, isFavorite: $isFavorite, folderId: $folderId, color: $color, isLocal: $isLocal)';
}


}

/// @nodoc
abstract mixin class _$NoteCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$NoteCopyWith(_Note value, $Res Function(_Note) _then) = __$NoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, DateTime createdAt, DateTime updatedAt, List<String> tags, List<String> attachments, bool isPinned, bool isArchived, bool isFavorite, String? folderId, String? color, bool? isLocal
});




}
/// @nodoc
class __$NoteCopyWithImpl<$Res>
    implements _$NoteCopyWith<$Res> {
  __$NoteCopyWithImpl(this._self, this._then);

  final _Note _self;
  final $Res Function(_Note) _then;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? tags = null,Object? attachments = null,Object? isPinned = null,Object? isArchived = null,Object? isFavorite = null,Object? folderId = freezed,Object? color = freezed,Object? isLocal = freezed,}) {
  return _then(_Note(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isLocal: freezed == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
