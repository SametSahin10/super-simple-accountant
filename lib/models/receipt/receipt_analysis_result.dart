import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt_analysis_result.g.dart';

@JsonSerializable(createToJson: false)
class ReceiptAnalysisResult {
  final String merchant;
  final String location;
  final String currencyCode;
  final List<ReceiptItem> items;
  final double total;

  const ReceiptAnalysisResult({
    required this.merchant,
    required this.location,
    required this.currencyCode,
    required this.items,
    required this.total,
  });

  factory ReceiptAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$ReceiptAnalysisResultFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReceiptItem {
  final String name;
  final String category;
  final double price;

  const ReceiptItem({
    required this.name,
    required this.category,
    required this.price,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}
