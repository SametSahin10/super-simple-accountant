import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/models/entries_state_model.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';

part 'entries_state_notifier.g.dart';

@riverpod
class EntriesStateNotifier extends _$EntriesStateNotifier {
  @override
  EntriesStateModel build() {
    state = EntriesStateModel.initial();
    getLocalEntries();
    return state;
  }

  void getLocalEntries() async {
    state = state.copyWith(widgetState: WidgetState.loading);
    final entryRepository = EntryRepository();
    final entries = await entryRepository.getEntries();
    state = state.copyWith(entries: entries, widgetState: WidgetState.loaded);
  }

  void addEntry(Entry entry) {
    final newEntries = [...state.entries, entry];
    state = state.copyWith(entries: newEntries);

    final entryRepository = EntryRepository();
    entryRepository.saveEntry(entry);
  }

  void deleteEntry(Entry entry) {
    final newEntries = state.entries.where((e) => e != entry).toList();
    state = state.copyWith(entries: newEntries);

    final entryRepository = EntryRepository();
    entryRepository.deleteEntry(entry);
  }

  double getNetAmount() {
    double netAmount = 0;

    for (final entry in state.entries) {
      netAmount += entry.amount;
    }

    return netAmount;
  }
}
