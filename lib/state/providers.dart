import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/models/add_entry_screen_model.dart';
import 'package:super_simple_accountant/models/category.dart';

part 'providers.g.dart';

@Riverpod(dependencies: [])
NumberFormat? currencyFormatter(Ref ref) => null;

@riverpod
AddEntryScreenModel addEntryScreenModel(Ref ref) {
  return AddEntryScreenModel();
}

@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  @override
  Category? build() => null;

  setSelectedCategory(Category category) {
    state = category;
  }
}
