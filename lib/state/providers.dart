import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/models/add_entry_screen_model.dart';
import 'package:super_simple_accountant/models/category.dart';

part 'providers.g.dart';

@riverpod
AddEntryScreenModel addEntryScreenModel(AddEntryScreenModelRef ref) {
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
