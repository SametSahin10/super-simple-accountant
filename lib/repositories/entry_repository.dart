import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_simple_accountant/models/entry.dart';

class EntryRepository {
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
}
