// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryImpl _$$EntryImplFromJson(Map<String, dynamic> json) => _$EntryImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      source: EntrySource.fromJson(json['source'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'category': instance.category,
      'source': instance.source,
    };

_$BasicEntrySourceImpl _$$BasicEntrySourceImplFromJson(
        Map<String, dynamic> json) =>
    _$BasicEntrySourceImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BasicEntrySourceImplToJson(
        _$BasicEntrySourceImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$ReceiptEntrySourceImpl _$$ReceiptEntrySourceImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceiptEntrySourceImpl(
      imagePath: json['imagePath'] as String,
      imageUrl: json['imageUrl'] as String?,
      merchantName: json['merchantName'] as String,
      rawText: json['rawText'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ReceiptEntrySourceImplToJson(
        _$ReceiptEntrySourceImpl instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'imageUrl': instance.imageUrl,
      'merchantName': instance.merchantName,
      'rawText': instance.rawText,
      'runtimeType': instance.$type,
    };
