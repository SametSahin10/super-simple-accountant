import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/models/entries_state_model.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';

class EntriesStateNotifier extends StateNotifier<EntriesStateModel> {
  final EntryRepository entryRepository;

  EntriesStateNotifier({
    required this.entryRepository,
    required EntriesStateModel entriesStateModel,
  }) : super(entriesStateModel) {
    getLocalEntries();
  }

  void getLocalEntries() async {
    state = state.copyWith(widgetState: WidgetState.loading);
    final entries = await entryRepository.getEntries();
    state = state.copyWith(entries: entries, widgetState: WidgetState.loaded);
  }

  void addEntry(Entry entry) {
    final newEntries = [...state.entries, entry];
    state = state.copyWith(entries: newEntries);

    entryRepository.saveEntry(entry);
  }

  double getNetAmount() {
    double netAmount = 0;

    for (final entry in state.entries) {
      netAmount += entry.amount;
    }

    return netAmount;
  }
}
