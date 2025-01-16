import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_simple_accountant/models/category.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class Entry with _$Entry {
  const factory Entry({
    required String id,
    required double amount,
    required DateTime createdAt,
    String? description,
    Category? category,
    required EntrySource source,
    @Default(false) bool isSynced,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}

@freezed
class EntrySource with _$EntrySource {
  const factory EntrySource.basic() = BasicEntrySource;

  const factory EntrySource.receipt({
    required String imagePath,
    String? imageUrl,
    required String merchantName,
    String? rawText,
  }) = ReceiptEntrySource;

  factory EntrySource.fromJson(Map<String, dynamic> json) =>
      _$EntrySourceFromJson(json);
}
