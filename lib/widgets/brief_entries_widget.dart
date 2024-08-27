import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/screens/all_entries_screen.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/widgets/entry_list_tile.dart';

class BriefEntriesWidget extends ConsumerWidget {
  final NumberFormat currencyFormatter;

  const BriefEntriesWidget({super.key, required this.currencyFormatter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);
    final allEntries = entriesStateModel.entries;

    final copyOfAllEntries = List<Entry>.from(allEntries);

    copyOfAllEntries.sort((first, second) {
      return second.createdAt.compareTo(first.createdAt);
    });

    final entries = copyOfAllEntries.take(3).toList();

    if (entries.isEmpty) return const SizedBox();

    final showShowMoreWidget = allEntries.length > 3;
    final entryListTiles = entries.map(_toEntryListTile).toList();

    final showMoreWidget = _ShowMoreWidget(
      currencyFormatter: currencyFormatter,
    );

    return Column(
      children: [...entryListTiles, if (showShowMoreWidget) showMoreWidget],
    );
  }

  EntryListTile _toEntryListTile(entry) {
    return EntryListTile(entry: entry, currencyFormatter: currencyFormatter);
  }
}

class _ShowMoreWidget extends StatelessWidget {
  final NumberFormat currencyFormatter;

  const _ShowMoreWidget({required this.currencyFormatter});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return AllEntriesScreen(
                currencyFormatter: currencyFormatter,
              );
            },
          ),
        );
      },
      child: Text(
        context.l10n.seeMore,
        style: TextStyle(fontSize: context.largerThanMobile ? 20.0 : 16.0),
      ),
    );
  }
}
