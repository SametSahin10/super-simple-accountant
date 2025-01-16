import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

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

    return entriesJson.map(
      (entryAsString) {
        return Entry.fromJson(
          jsonDecode(entryAsString),
        );
      },
    ).toList();
  }

  Future<void> markEntrySynced(Entry entry) async {
    final syncedEntry = entry.copyWith(isSynced: true);
    await saveEntry(syncedEntry);
  }

  Future<void> syncWithRemote(List<Entry> remoteEntries) async {
    for (final entry in remoteEntries) {
      final syncedEntry = entry.copyWith(isSynced: true);
      await saveEntry(syncedEntry);
    }
  }
}
