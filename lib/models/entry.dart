import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_simple_accountant/models/category.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class Entry with _$Entry {
  factory Entry({
    required double amount,
    required DateTime createdAt,
    String? description,
    Category? category,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}
