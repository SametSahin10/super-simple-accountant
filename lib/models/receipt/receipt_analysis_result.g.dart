// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptAnalysisResult _$ReceiptAnalysisResultFromJson(
        Map<String, dynamic> json) =>
    ReceiptAnalysisResult(
      merchant: json['merchant'] as String,
      location: json['location'] as String,
      currencyCode: json['currencyCode'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      date: ReceiptAnalysisResult._dateFromJson(json['date']),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );

ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) => ReceiptItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
