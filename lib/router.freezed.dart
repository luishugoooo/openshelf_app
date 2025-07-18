// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'router.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeRoute {

 String get path; String get label; IconData get icon;
/// Create a copy of HomeRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeRouteCopyWith<HomeRoute> get copyWith => _$HomeRouteCopyWithImpl<HomeRoute>(this as HomeRoute, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeRoute&&(identical(other.path, path) || other.path == path)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,path,label,icon);

@override
String toString() {
  return 'HomeRoute(path: $path, label: $label, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $HomeRouteCopyWith<$Res>  {
  factory $HomeRouteCopyWith(HomeRoute value, $Res Function(HomeRoute) _then) = _$HomeRouteCopyWithImpl;
@useResult
$Res call({
 String path, String label, IconData icon
});




}
/// @nodoc
class _$HomeRouteCopyWithImpl<$Res>
    implements $HomeRouteCopyWith<$Res> {
  _$HomeRouteCopyWithImpl(this._self, this._then);

  final HomeRoute _self;
  final $Res Function(HomeRoute) _then;

/// Create a copy of HomeRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? label = null,Object? icon = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeRoute].
extension HomeRoutePatterns on HomeRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeRoute value)  $default,){
final _that = this;
switch (_that) {
case _HomeRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeRoute value)?  $default,){
final _that = this;
switch (_that) {
case _HomeRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String label,  IconData icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeRoute() when $default != null:
return $default(_that.path,_that.label,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String label,  IconData icon)  $default,) {final _that = this;
switch (_that) {
case _HomeRoute():
return $default(_that.path,_that.label,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String label,  IconData icon)?  $default,) {final _that = this;
switch (_that) {
case _HomeRoute() when $default != null:
return $default(_that.path,_that.label,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _HomeRoute implements HomeRoute {
  const _HomeRoute({required this.path, required this.label, required this.icon});
  

@override final  String path;
@override final  String label;
@override final  IconData icon;

/// Create a copy of HomeRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeRouteCopyWith<_HomeRoute> get copyWith => __$HomeRouteCopyWithImpl<_HomeRoute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeRoute&&(identical(other.path, path) || other.path == path)&&(identical(other.label, label) || other.label == label)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,path,label,icon);

@override
String toString() {
  return 'HomeRoute(path: $path, label: $label, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$HomeRouteCopyWith<$Res> implements $HomeRouteCopyWith<$Res> {
  factory _$HomeRouteCopyWith(_HomeRoute value, $Res Function(_HomeRoute) _then) = __$HomeRouteCopyWithImpl;
@override @useResult
$Res call({
 String path, String label, IconData icon
});




}
/// @nodoc
class __$HomeRouteCopyWithImpl<$Res>
    implements _$HomeRouteCopyWith<$Res> {
  __$HomeRouteCopyWithImpl(this._self, this._then);

  final _HomeRoute _self;
  final $Res Function(_HomeRoute) _then;

/// Create a copy of HomeRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? label = null,Object? icon = null,}) {
  return _then(_HomeRoute(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,
  ));
}


}

// dart format on
