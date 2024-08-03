import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/entry_list_tile.dart';

class AllEntriesScreen extends ConsumerWidget {
  final NumberFormat currencyFormatter;

  const AllEntriesScreen({
    super.key,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);
    final allEntries = entriesStateModel.entries;

    final copyOfAllEntries = List<Entry>.from(allEntries);

    copyOfAllEntries.sort((first, second) {
      return second.createdAt.compareTo(first.createdAt);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Entries'),
      ),
      body: ListView(
        children: copyOfAllEntries.map(_toEntryListTile).toList(),
      ),
    );
  }

  EntryListTile _toEntryListTile(entry) {
    return EntryListTile(entry: entry, currencyFormatter: currencyFormatter);
  }
}
