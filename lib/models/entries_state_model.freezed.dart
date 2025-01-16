// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entries_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EntriesStateModel _$EntriesStateModelFromJson(Map<String, dynamic> json) {
  return _EntriesStateModel.fromJson(json);
}

/// @nodoc
mixin _$EntriesStateModel {
  List<Entry> get entries => throw _privateConstructorUsedError;
  WidgetState get widgetState => throw _privateConstructorUsedError;
  bool get isSyncing => throw _privateConstructorUsedError;

  /// Serializes this EntriesStateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EntriesStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntriesStateModelCopyWith<EntriesStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntriesStateModelCopyWith<$Res> {
  factory $EntriesStateModelCopyWith(
          EntriesStateModel value, $Res Function(EntriesStateModel) then) =
      _$EntriesStateModelCopyWithImpl<$Res, EntriesStateModel>;
  @useResult
  $Res call({List<Entry> entries, WidgetState widgetState, bool isSyncing});
}

/// @nodoc
class _$EntriesStateModelCopyWithImpl<$Res, $Val extends EntriesStateModel>
    implements $EntriesStateModelCopyWith<$Res> {
  _$EntriesStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntriesStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? widgetState = null,
    Object? isSyncing = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<Entry>,
      widgetState: null == widgetState
          ? _value.widgetState
          : widgetState // ignore: cast_nullable_to_non_nullable
              as WidgetState,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntriesStateModelImplCopyWith<$Res>
    implements $EntriesStateModelCopyWith<$Res> {
  factory _$$EntriesStateModelImplCopyWith(_$EntriesStateModelImpl value,
          $Res Function(_$EntriesStateModelImpl) then) =
      __$$EntriesStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Entry> entries, WidgetState widgetState, bool isSyncing});
}

/// @nodoc
class __$$EntriesStateModelImplCopyWithImpl<$Res>
    extends _$EntriesStateModelCopyWithImpl<$Res, _$EntriesStateModelImpl>
    implements _$$EntriesStateModelImplCopyWith<$Res> {
  __$$EntriesStateModelImplCopyWithImpl(_$EntriesStateModelImpl _value,
      $Res Function(_$EntriesStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntriesStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? widgetState = null,
    Object? isSyncing = null,
  }) {
    return _then(_$EntriesStateModelImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<Entry>,
      widgetState: null == widgetState
          ? _value.widgetState
          : widgetState // ignore: cast_nullable_to_non_nullable
              as WidgetState,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntriesStateModelImpl implements _EntriesStateModel {
  _$EntriesStateModelImpl(
      {required final List<Entry> entries,
      required this.widgetState,
      required this.isSyncing})
      : _entries = entries;

  factory _$EntriesStateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntriesStateModelImplFromJson(json);

  final List<Entry> _entries;
  @override
  List<Entry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final WidgetState widgetState;
  @override
  final bool isSyncing;

  @override
  String toString() {
    return 'EntriesStateModel(entries: $entries, widgetState: $widgetState, isSyncing: $isSyncing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntriesStateModelImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.widgetState, widgetState) ||
                other.widgetState == widgetState) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_entries), widgetState, isSyncing);

  /// Create a copy of EntriesStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntriesStateModelImplCopyWith<_$EntriesStateModelImpl> get copyWith =>
      __$$EntriesStateModelImplCopyWithImpl<_$EntriesStateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntriesStateModelImplToJson(
      this,
    );
  }
}

abstract class _EntriesStateModel implements EntriesStateModel {
  factory _EntriesStateModel(
      {required final List<Entry> entries,
      required final WidgetState widgetState,
      required final bool isSyncing}) = _$EntriesStateModelImpl;

  factory _EntriesStateModel.fromJson(Map<String, dynamic> json) =
      _$EntriesStateModelImpl.fromJson;

  @override
  List<Entry> get entries;
  @override
  WidgetState get widgetState;
  @override
  bool get isSyncing;

  /// Create a copy of EntriesStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntriesStateModelImplCopyWith<_$EntriesStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
