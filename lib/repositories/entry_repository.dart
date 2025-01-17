import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/data_sources/entry_local_data_source.dart';
import 'package:super_simple_accountant/data_sources/entry_remote_data_source.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/services/connectivity_service.dart';

class EntryRepository {
  final _entryRemoteDataSource = EntryRemoteDataSource();
  final _entryLocalDataSource = EntryLocalDataSource();
  final _connectivityService = ConnectivityService();

  Future<void> syncLocalEntriesToRemote(String userId) async {
    try {
      debugPrint('Syncing local entries to remote...');

      if (!await _connectivityService.hasInternetConnection()) return;

      final localEntries = await _entryLocalDataSource.getEntries();

      for (final entry in localEntries) {
        if (entry.isSynced) continue;

        try {
          await _entryRemoteDataSource.createEntry(entry);
          await _entryLocalDataSource.markEntrySynced(entry);
        } catch (e) {
          continue;
        }
      }
    } catch (e, stack) {
      debugPrint('Error syncing local entries to remote: $e');
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> saveEntry({
    required Entry entry,
    required bool isPlusUser,
  }) async {
    final unsyncedEntry = entry.copyWith(isSynced: false);
    await _entryLocalDataSource.saveEntry(unsyncedEntry);

    if (await _connectivityService.hasInternetConnection() && isPlusUser) {
      try {
        await _entryRemoteDataSource.createEntry(entry);
        await _entryLocalDataSource.saveEntry(entry);
      } catch (e) {
        // Handle error but don't rethrow since local save succeeded
      }
    }
  }

  Future<void> deleteEntry({
    required Entry entry,
    required bool isPlusUser,
  }) async {
    await _entryLocalDataSource.deleteEntry(entry);

    if (await _connectivityService.hasInternetConnection() && isPlusUser) {
      try {
        await _entryRemoteDataSource.deleteEntry(entry);
      } catch (e) {
        // Handle error but don't rethrow since local delete succeeded
      }
    }
  }

  Future<List<Entry>> getEntries({
    String? userId,
    required bool isPlusUser,
  }) async {
    try {
      final hasInternetConnection =
          await _connectivityService.hasInternetConnection();

      final getRemoteEntries =
          hasInternetConnection && userId != null && isPlusUser;

      if (getRemoteEntries) {
        try {
          final remoteEntries =
              await _entryRemoteDataSource.getAllEntries(userId: userId);
          // Update local storage with remote data
          await _entryLocalDataSource.syncWithRemote(remoteEntries);
          return remoteEntries;
        } catch (e) {
          return await _entryLocalDataSource.getEntries();
        }
      }

      return await _entryLocalDataSource.getEntries();
    } catch (err) {
      FirebaseCrashlytics.instance.recordError(
        'Error getting entries: $err',
        StackTrace.current,
      );

      rethrow;
    }
  }
}
