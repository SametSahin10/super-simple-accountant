import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:super_simple_accountant/models/category.dart';

part 'receipt_analysis_result.g.dart';

@JsonSerializable(createToJson: false)
class ReceiptAnalysisResult {
  final String merchant;
  final String location;

  @JsonKey(
    name: 'date',
    fromJson: _dateFromJson,
  )
  final DateTime date;

  final Category category;

  final String currencyCode;
  final List<ReceiptItem> items;
  final double total;

  const ReceiptAnalysisResult({
    required this.merchant,
    required this.location,
    required this.currencyCode,
    required this.items,
    required this.total,
    required this.date,
    required this.category,
  });

  factory ReceiptAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$ReceiptAnalysisResultFromJson(json);

  static DateTime _dateFromJson(dynamic timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp as int);
}

@JsonSerializable(createToJson: false)
class ReceiptItem {
  final String name;
  final double price;

  const ReceiptItem({
    required this.name,
    required this.price,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}
