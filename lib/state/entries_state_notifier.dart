import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/models/entries_state_model.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';
import 'package:super_simple_accountant/services/connectivity_service.dart';
import 'package:super_simple_accountant/state/entitlement_notifier.dart';

part 'entries_state_notifier.g.dart';

@riverpod
class EntriesStateNotifier extends _$EntriesStateNotifier {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  EntriesStateModel build() {
    state = EntriesStateModel.initial();
    getEntries();

    _connectivitySubscription ??= syncEntriesWhenConnected();

    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    return state;
  }

  void getEntries() async {
    state = state.copyWith(widgetState: WidgetState.loading);
    final entryRepository = EntryRepository();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    final entries = await entryRepository.getEntries(
      userId: userId!,
      isPlusUser: isPlusUser(),
    );

    state = state.copyWith(entries: entries, widgetState: WidgetState.loaded);
  }

  void addEntry(Entry entry) {
    final newEntries = [...state.entries, entry];
    state = state.copyWith(entries: newEntries);

    final entryRepository = EntryRepository();

    entryRepository.saveEntry(
      entry: entry,
      isPlusUser: isPlusUser(),
    );
  }

  void deleteEntry(Entry entry) {
    final newEntries = state.entries.where((e) => e != entry).toList();
    state = state.copyWith(entries: newEntries);

    final entryRepository = EntryRepository();

    entryRepository.deleteEntry(
      entry: entry,
      isPlusUser: isPlusUser(),
    );
  }

  double getNetAmount() {
    double netAmount = 0;

    for (final entry in state.entries) {
      netAmount += entry.amount;
    }

    return netAmount;
  }

  bool isPlusUser() {
    final entitlement = ref.watch(entitlementNotifierProvider);
    return entitlement == Entitlement.plus;
  }

  StreamSubscription<List<ConnectivityResult>> syncEntriesWhenConnected() {
    final entitlement = ref.watch(entitlementNotifierProvider);

    final onConnectivityChanged = Connectivity().onConnectivityChanged;

    return onConnectivityChanged.listen((result) async {
      // Entries are synced only for Plus users
      if (entitlement != Entitlement.plus) return;

      final connectivityService = ConnectivityService();
      final isConnected = connectivityService.checkIfConnectedByResult(result);

      final entryRepository = EntryRepository();
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (isConnected) {
        state = state.copyWith(isSyncing: true);
        await entryRepository.syncLocalEntriesToRemote(userId!);
        state = state.copyWith(isSyncing: false);
      }
    });
  }
}
