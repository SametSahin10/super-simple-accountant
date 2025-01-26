import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:super_simple_accountant/data_sources/entry_local_data_source.dart';
import 'package:super_simple_accountant/data_sources/entry_remote_data_source.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/services/connectivity_service.dart';

@lazySingleton
class EntryRepository {
  final EntryRemoteDataSource entryRemoteDataSource;
  final EntryLocalDataSource entryLocalDataSource;
  final ConnectivityService connectivityService;

  EntryRepository({
    required this.entryRemoteDataSource,
    required this.entryLocalDataSource,
    required this.connectivityService,
  });

  Future<void> syncLocalEntriesToRemote(String userId) async {
    try {
      debugPrint('Syncing local entries to remote...');

      if (!await connectivityService.hasInternetConnection()) return;

      final localEntries = await entryLocalDataSource.getEntries();

      for (final entry in localEntries) {
        if (entry.isSynced) continue;

        try {
          await entryRemoteDataSource.createEntry(entry);
          await entryLocalDataSource.markEntrySynced(entry);
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
    // Save locally first
    await entryLocalDataSource.saveEntry(entry.copyWith(isSynced: false));

    if (await connectivityService.hasInternetConnection() && isPlusUser) {
      try {
        await entryRemoteDataSource.createEntry(entry);
        // Just mark as synced instead of full save
        await entryLocalDataSource.markEntrySynced(entry);
      } catch (e) {
        // Handle error but don't rethrow since local save succeeded
      }
    }
  }

  Future<void> deleteEntry({
    required Entry entry,
    required bool isPlusUser,
  }) async {
    await entryLocalDataSource.deleteEntry(entry);

    if (await connectivityService.hasInternetConnection() && isPlusUser) {
      try {
        await entryRemoteDataSource.deleteEntry(entry);
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
          await connectivityService.hasInternetConnection();

      final getRemoteEntries =
          hasInternetConnection && userId != null && isPlusUser;

      if (getRemoteEntries) {
        try {
          final remoteEntries =
              await entryRemoteDataSource.getAllEntries(userId: userId);
          // Update local storage with remote data
          await entryLocalDataSource.syncWithRemote(remoteEntries);
          return remoteEntries;
        } catch (e) {
          return await entryLocalDataSource.getEntries();
        }
      }

      return await entryLocalDataSource.getEntries();
    } catch (err) {
      FirebaseCrashlytics.instance.recordError(
        'Error getting entries: $err',
        StackTrace.current,
      );

      rethrow;
    }
  }
}
