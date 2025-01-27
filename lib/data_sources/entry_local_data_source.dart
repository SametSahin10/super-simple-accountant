import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

@lazySingleton
class EntryLocalDataSource {
  static const String _key = 'entries';

  Future<void> saveEntry(Entry entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<Entry> entries = await getEntries();
    entries.add(entry);
    await prefs.setStringList(
      _key,
      entries.map(
        (entry) {
          return jsonEncode(entry.toJson());
        },
      ).toList(),
    );
  }

  Future<void> deleteEntry(Entry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    final newEntries = entries.where((e) => e != entry).toList();

    await prefs.setStringList(
      _key,
      newEntries.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  Future<List<Entry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_key) ?? [];

    final entries = <Entry>[];

    for (final entryAsString in entriesJson) {
      try {
        final entry = Entry.fromJson(jsonDecode(entryAsString));
        entries.add(entry);
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(
          'Failed to parse entry: $e. Entry: $entryAsString',
          StackTrace.current,
        );
      }
    }

    return entries;
  }

  Future<void> markEntrySynced(Entry entry) async {
    final syncedEntry = entry.copyWith(isSynced: true);
    await saveEntry(syncedEntry);
  }

  Future<void> syncWithRemote(List<Entry> remoteEntries) async {
    await clearEntries();

    for (final entry in remoteEntries) {
      final syncedEntry = entry.copyWith(isSynced: true);
      await saveEntry(syncedEntry);
    }
  }

  Future<void> clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
