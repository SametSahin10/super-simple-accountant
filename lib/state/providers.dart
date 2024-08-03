import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/models/add_entry_screen_model.dart';
import 'package:super_simple_accountant/models/entries_state_model.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';

final entriesStateNotifierProvider =
    StateNotifierProvider<EntriesStateNotifier, EntriesStateModel>((_) {
  final entriesStateModel = EntriesStateModel.initial();
  final entryRepository = EntryRepository();

  return EntriesStateNotifier(
    entryRepository: entryRepository,
    entriesStateModel: entriesStateModel,
  );
});

final addEntryScreenModelProvider =
    Provider.autoDispose<AddEntryScreenModel>((_) {
  return AddEntryScreenModel();
});
