// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEvent {

 String get id; String? get googleEventId; String? get taskId; String? get noteId; String get title; String? get description; DateTime? get startTime; DateTime? get endTime; bool? get isAllDay; String? get location; String get source;// 'google_calendar', 'app_task', 'app_note'
 DateTime get createdAt; DateTime get updatedAt; DateTime? get lastSyncedAt;
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<CalendarEvent> get copyWith => _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.googleEventId, googleEventId) || other.googleEventId == googleEventId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleEventId,taskId,noteId,title,description,startTime,endTime,isAllDay,location,source,createdAt,updatedAt,lastSyncedAt);

@override
String toString() {
  return 'CalendarEvent(id: $id, googleEventId: $googleEventId, taskId: $taskId, noteId: $noteId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, location: $location, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res>  {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) = _$CalendarEventCopyWithImpl;
@useResult
$Res call({
 String id, String? googleEventId, String? taskId, String? noteId, String title, String? description, DateTime? startTime, DateTime? endTime, bool? isAllDay, String? location, String source, DateTime createdAt, DateTime updatedAt, DateTime? lastSyncedAt
});




}
/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? googleEventId = freezed,Object? taskId = freezed,Object? noteId = freezed,Object? title = null,Object? description = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? isAllDay = freezed,Object? location = freezed,Object? source = null,Object? createdAt = null,Object? updatedAt = null,Object? lastSyncedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleEventId: freezed == googleEventId ? _self.googleEventId : googleEventId // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllDay: freezed == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEvent].
extension CalendarEventPatterns on CalendarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEvent value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? googleEventId,  String? taskId,  String? noteId,  String title,  String? description,  DateTime? startTime,  DateTime? endTime,  bool? isAllDay,  String? location,  String source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.googleEventId,_that.taskId,_that.noteId,_that.title,_that.description,_that.startTime,_that.endTime,_that.isAllDay,_that.location,_that.source,_that.createdAt,_that.updatedAt,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? googleEventId,  String? taskId,  String? noteId,  String title,  String? description,  DateTime? startTime,  DateTime? endTime,  bool? isAllDay,  String? location,  String source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent():
return $default(_that.id,_that.googleEventId,_that.taskId,_that.noteId,_that.title,_that.description,_that.startTime,_that.endTime,_that.isAllDay,_that.location,_that.source,_that.createdAt,_that.updatedAt,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? googleEventId,  String? taskId,  String? noteId,  String title,  String? description,  DateTime? startTime,  DateTime? endTime,  bool? isAllDay,  String? location,  String source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.googleEventId,_that.taskId,_that.noteId,_that.title,_that.description,_that.startTime,_that.endTime,_that.isAllDay,_that.location,_that.source,_that.createdAt,_that.updatedAt,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarEvent implements CalendarEvent {
  const _CalendarEvent({required this.id, this.googleEventId, this.taskId, this.noteId, required this.title, this.description, this.startTime, this.endTime, this.isAllDay, this.location, required this.source, required this.createdAt, required this.updatedAt, this.lastSyncedAt});
  factory _CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

@override final  String id;
@override final  String? googleEventId;
@override final  String? taskId;
@override final  String? noteId;
@override final  String title;
@override final  String? description;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override final  bool? isAllDay;
@override final  String? location;
@override final  String source;
// 'google_calendar', 'app_task', 'app_note'
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? lastSyncedAt;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventCopyWith<_CalendarEvent> get copyWith => __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.googleEventId, googleEventId) || other.googleEventId == googleEventId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleEventId,taskId,noteId,title,description,startTime,endTime,isAllDay,location,source,createdAt,updatedAt,lastSyncedAt);

@override
String toString() {
  return 'CalendarEvent(id: $id, googleEventId: $googleEventId, taskId: $taskId, noteId: $noteId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, location: $location, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) = __$CalendarEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String? googleEventId, String? taskId, String? noteId, String title, String? description, DateTime? startTime, DateTime? endTime, bool? isAllDay, String? location, String source, DateTime createdAt, DateTime updatedAt, DateTime? lastSyncedAt
});




}
/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? googleEventId = freezed,Object? taskId = freezed,Object? noteId = freezed,Object? title = null,Object? description = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? isAllDay = freezed,Object? location = freezed,Object? source = null,Object? createdAt = null,Object? updatedAt = null,Object? lastSyncedAt = freezed,}) {
  return _then(_CalendarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleEventId: freezed == googleEventId ? _self.googleEventId : googleEventId // ignore: cast_nullable_to_non_nullable
as String?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isAllDay: freezed == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
