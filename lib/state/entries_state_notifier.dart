import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/di/di.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/models/entries_state_model.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';
import 'package:super_simple_accountant/services/connectivity_service.dart';
import 'package:super_simple_accountant/state/entitlement_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';

part 'entries_state_notifier.g.dart';

@riverpod
class EntriesStateNotifier extends _$EntriesStateNotifier {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  EntriesStateModel build() {
    state = EntriesStateModel.initial();
    getEntries();

    _connectivitySubscription ??= syncEntriesWhenConnected();

    // Watch entitlement changes and sync when becoming Plus
    ref.listen(entitlementNotifierProvider, (previous, next) {
      if (previous != Entitlement.plus && next == Entitlement.plus) {
        _syncEntries();
      }
    });

    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    return state;
  }

  void getEntries() async {
    try {
      state = state.copyWith(widgetState: WidgetState.loading);
      final entryRepository = getIt<EntryRepository>();

      final userAsyncValue = await ref.watch(userStreamProvider.future);
      final userId = userAsyncValue?.uid;

      if (userId == null) {
        FirebaseCrashlytics.instance.recordError(
          'getEntries has been called with a null user ID. This should not happen.',
          StackTrace.current,
        );
      }

      final entries = await entryRepository.getEntries(
        userId: userId,
        isPlusUser: isPlusUser(),
      );

      state = state.copyWith(entries: entries, widgetState: WidgetState.loaded);
    } catch (err) {
      debugPrint('Error getting entries: $err');
      state = state.copyWith(widgetState: WidgetState.error);
    }
  }

  void addEntry(Entry entry) {
    final newEntries = [...state.entries, entry];
    state = state.copyWith(entries: newEntries);

    final entryRepository = getIt<EntryRepository>();

    entryRepository.saveEntry(
      entry: entry,
      isPlusUser: isPlusUser(),
    );
  }

  void deleteEntry(Entry entry) {
    final newEntries = state.entries.where((e) => e != entry).toList();
    state = state.copyWith(entries: newEntries);

    final entryRepository = getIt<EntryRepository>();

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

      if (isConnected) _syncEntries();
    });
  }

  Future<void> _syncEntries() async {
    final entryRepository = getIt<EntryRepository>();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      state = state.copyWith(isSyncing: true);
      await entryRepository.syncLocalEntriesToRemote(userId);
      state = state.copyWith(isSyncing: false);

      // Get entries again.
      //This ensures that the entries from remote are fetched.
      getEntries();
    }
  }
}
