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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EntriesStateModelCopyWith<EntriesStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntriesStateModelCopyWith<$Res> {
  factory $EntriesStateModelCopyWith(
          EntriesStateModel value, $Res Function(EntriesStateModel) then) =
      _$EntriesStateModelCopyWithImpl<$Res, EntriesStateModel>;
  @useResult
  $Res call({List<Entry> entries, WidgetState widgetState});
}

/// @nodoc
class _$EntriesStateModelCopyWithImpl<$Res, $Val extends EntriesStateModel>
    implements $EntriesStateModelCopyWith<$Res> {
  _$EntriesStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? widgetState = null,
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
  $Res call({List<Entry> entries, WidgetState widgetState});
}

/// @nodoc
class __$$EntriesStateModelImplCopyWithImpl<$Res>
    extends _$EntriesStateModelCopyWithImpl<$Res, _$EntriesStateModelImpl>
    implements _$$EntriesStateModelImplCopyWith<$Res> {
  __$$EntriesStateModelImplCopyWithImpl(_$EntriesStateModelImpl _value,
      $Res Function(_$EntriesStateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? widgetState = null,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntriesStateModelImpl implements _EntriesStateModel {
  _$EntriesStateModelImpl(
      {required final List<Entry> entries, required this.widgetState})
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
  String toString() {
    return 'EntriesStateModel(entries: $entries, widgetState: $widgetState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntriesStateModelImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.widgetState, widgetState) ||
                other.widgetState == widgetState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_entries), widgetState);

  @JsonKey(ignore: true)
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
      required final WidgetState widgetState}) = _$EntriesStateModelImpl;

  factory _EntriesStateModel.fromJson(Map<String, dynamic> json) =
      _$EntriesStateModelImpl.fromJson;

  @override
  List<Entry> get entries;
  @override
  WidgetState get widgetState;
  @override
  @JsonKey(ignore: true)
  _$$EntriesStateModelImplCopyWith<_$EntriesStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
