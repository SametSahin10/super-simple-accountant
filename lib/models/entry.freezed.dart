// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return _Entry.fromJson(json);
}

/// @nodoc
mixin _$Entry {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  EntrySource get source => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Serializes this Entry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryCopyWith<Entry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryCopyWith<$Res> {
  factory $EntryCopyWith(Entry value, $Res Function(Entry) then) =
      _$EntryCopyWithImpl<$Res, Entry>;
  @useResult
  $Res call(
      {String id,
      double amount,
      DateTime createdAt,
      String? description,
      Category? category,
      EntrySource source,
      bool isSynced});

  $CategoryCopyWith<$Res>? get category;
  $EntrySourceCopyWith<$Res> get source;
}

/// @nodoc
class _$EntryCopyWithImpl<$Res, $Val extends Entry>
    implements $EntryCopyWith<$Res> {
  _$EntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? source = null,
    Object? isSynced = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EntrySource,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EntrySourceCopyWith<$Res> get source {
    return $EntrySourceCopyWith<$Res>(_value.source, (value) {
      return _then(_value.copyWith(source: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EntryImplCopyWith<$Res> implements $EntryCopyWith<$Res> {
  factory _$$EntryImplCopyWith(
          _$EntryImpl value, $Res Function(_$EntryImpl) then) =
      __$$EntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      DateTime createdAt,
      String? description,
      Category? category,
      EntrySource source,
      bool isSynced});

  @override
  $CategoryCopyWith<$Res>? get category;
  @override
  $EntrySourceCopyWith<$Res> get source;
}

/// @nodoc
class __$$EntryImplCopyWithImpl<$Res>
    extends _$EntryCopyWithImpl<$Res, _$EntryImpl>
    implements _$$EntryImplCopyWith<$Res> {
  __$$EntryImplCopyWithImpl(
      _$EntryImpl _value, $Res Function(_$EntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? source = null,
    Object? isSynced = null,
  }) {
    return _then(_$EntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as EntrySource,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntryImpl implements _Entry {
  const _$EntryImpl(
      {required this.id,
      required this.amount,
      required this.createdAt,
      this.description,
      this.category,
      required this.source,
      this.isSynced = false});

  factory _$EntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryImplFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final Category? category;
  @override
  final EntrySource source;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'Entry(id: $id, amount: $amount, createdAt: $createdAt, description: $description, category: $category, source: $source, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, createdAt,
      description, category, source, isSynced);

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      __$$EntryImplCopyWithImpl<_$EntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryImplToJson(
      this,
    );
  }
}

abstract class _Entry implements Entry {
  const factory _Entry(
      {required final String id,
      required final double amount,
      required final DateTime createdAt,
      final String? description,
      final Category? category,
      required final EntrySource source,
      final bool isSynced}) = _$EntryImpl;

  factory _Entry.fromJson(Map<String, dynamic> json) = _$EntryImpl.fromJson;

  @override
  String get id;
  @override
  double get amount;
  @override
  DateTime get createdAt;
  @override
  String? get description;
  @override
  Category? get category;
  @override
  EntrySource get source;
  @override
  bool get isSynced;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntrySource _$EntrySourceFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'basic':
      return BasicEntrySource.fromJson(json);
    case 'receipt':
      return ReceiptEntrySource.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'EntrySource',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$EntrySource {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() basic,
    required TResult Function(String imagePath, String? imageUrl,
            String merchantName, String? rawText)
        receipt,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? basic,
    TResult? Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? basic,
    TResult Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BasicEntrySource value) basic,
    required TResult Function(ReceiptEntrySource value) receipt,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BasicEntrySource value)? basic,
    TResult? Function(ReceiptEntrySource value)? receipt,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BasicEntrySource value)? basic,
    TResult Function(ReceiptEntrySource value)? receipt,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this EntrySource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntrySourceCopyWith<$Res> {
  factory $EntrySourceCopyWith(
          EntrySource value, $Res Function(EntrySource) then) =
      _$EntrySourceCopyWithImpl<$Res, EntrySource>;
}

/// @nodoc
class _$EntrySourceCopyWithImpl<$Res, $Val extends EntrySource>
    implements $EntrySourceCopyWith<$Res> {
  _$EntrySourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntrySource
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BasicEntrySourceImplCopyWith<$Res> {
  factory _$$BasicEntrySourceImplCopyWith(_$BasicEntrySourceImpl value,
          $Res Function(_$BasicEntrySourceImpl) then) =
      __$$BasicEntrySourceImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BasicEntrySourceImplCopyWithImpl<$Res>
    extends _$EntrySourceCopyWithImpl<$Res, _$BasicEntrySourceImpl>
    implements _$$BasicEntrySourceImplCopyWith<$Res> {
  __$$BasicEntrySourceImplCopyWithImpl(_$BasicEntrySourceImpl _value,
      $Res Function(_$BasicEntrySourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntrySource
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$BasicEntrySourceImpl implements BasicEntrySource {
  const _$BasicEntrySourceImpl({final String? $type})
      : $type = $type ?? 'basic';

  factory _$BasicEntrySourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicEntrySourceImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EntrySource.basic()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BasicEntrySourceImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() basic,
    required TResult Function(String imagePath, String? imageUrl,
            String merchantName, String? rawText)
        receipt,
  }) {
    return basic();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? basic,
    TResult? Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
  }) {
    return basic?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? basic,
    TResult Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
    required TResult orElse(),
  }) {
    if (basic != null) {
      return basic();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BasicEntrySource value) basic,
    required TResult Function(ReceiptEntrySource value) receipt,
  }) {
    return basic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BasicEntrySource value)? basic,
    TResult? Function(ReceiptEntrySource value)? receipt,
  }) {
    return basic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BasicEntrySource value)? basic,
    TResult Function(ReceiptEntrySource value)? receipt,
    required TResult orElse(),
  }) {
    if (basic != null) {
      return basic(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicEntrySourceImplToJson(
      this,
    );
  }
}

abstract class BasicEntrySource implements EntrySource {
  const factory BasicEntrySource() = _$BasicEntrySourceImpl;

  factory BasicEntrySource.fromJson(Map<String, dynamic> json) =
      _$BasicEntrySourceImpl.fromJson;
}

/// @nodoc
abstract class _$$ReceiptEntrySourceImplCopyWith<$Res> {
  factory _$$ReceiptEntrySourceImplCopyWith(_$ReceiptEntrySourceImpl value,
          $Res Function(_$ReceiptEntrySourceImpl) then) =
      __$$ReceiptEntrySourceImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String imagePath,
      String? imageUrl,
      String merchantName,
      String? rawText});
}

/// @nodoc
class __$$ReceiptEntrySourceImplCopyWithImpl<$Res>
    extends _$EntrySourceCopyWithImpl<$Res, _$ReceiptEntrySourceImpl>
    implements _$$ReceiptEntrySourceImplCopyWith<$Res> {
  __$$ReceiptEntrySourceImplCopyWithImpl(_$ReceiptEntrySourceImpl _value,
      $Res Function(_$ReceiptEntrySourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntrySource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? imageUrl = freezed,
    Object? merchantName = null,
    Object? rawText = freezed,
  }) {
    return _then(_$ReceiptEntrySourceImpl(
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      rawText: freezed == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptEntrySourceImpl implements ReceiptEntrySource {
  const _$ReceiptEntrySourceImpl(
      {required this.imagePath,
      this.imageUrl,
      required this.merchantName,
      this.rawText,
      final String? $type})
      : $type = $type ?? 'receipt';

  factory _$ReceiptEntrySourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptEntrySourceImplFromJson(json);

  @override
  final String imagePath;
  @override
  final String? imageUrl;
  @override
  final String merchantName;
  @override
  final String? rawText;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EntrySource.receipt(imagePath: $imagePath, imageUrl: $imageUrl, merchantName: $merchantName, rawText: $rawText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptEntrySourceImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.rawText, rawText) || other.rawText == rawText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imagePath, imageUrl, merchantName, rawText);

  /// Create a copy of EntrySource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptEntrySourceImplCopyWith<_$ReceiptEntrySourceImpl> get copyWith =>
      __$$ReceiptEntrySourceImplCopyWithImpl<_$ReceiptEntrySourceImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() basic,
    required TResult Function(String imagePath, String? imageUrl,
            String merchantName, String? rawText)
        receipt,
  }) {
    return receipt(imagePath, imageUrl, merchantName, rawText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? basic,
    TResult? Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
  }) {
    return receipt?.call(imagePath, imageUrl, merchantName, rawText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? basic,
    TResult Function(String imagePath, String? imageUrl, String merchantName,
            String? rawText)?
        receipt,
    required TResult orElse(),
  }) {
    if (receipt != null) {
      return receipt(imagePath, imageUrl, merchantName, rawText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BasicEntrySource value) basic,
    required TResult Function(ReceiptEntrySource value) receipt,
  }) {
    return receipt(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BasicEntrySource value)? basic,
    TResult? Function(ReceiptEntrySource value)? receipt,
  }) {
    return receipt?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BasicEntrySource value)? basic,
    TResult Function(ReceiptEntrySource value)? receipt,
    required TResult orElse(),
  }) {
    if (receipt != null) {
      return receipt(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptEntrySourceImplToJson(
      this,
    );
  }
}

abstract class ReceiptEntrySource implements EntrySource {
  const factory ReceiptEntrySource(
      {required final String imagePath,
      final String? imageUrl,
      required final String merchantName,
      final String? rawText}) = _$ReceiptEntrySourceImpl;

  factory ReceiptEntrySource.fromJson(Map<String, dynamic> json) =
      _$ReceiptEntrySourceImpl.fromJson;

  String get imagePath;
  String? get imageUrl;
  String get merchantName;
  String? get rawText;

  /// Create a copy of EntrySource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptEntrySourceImplCopyWith<_$ReceiptEntrySourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
