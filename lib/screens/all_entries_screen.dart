import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/controllers/export_entries_controller.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/widgets/entry_list_tile.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';

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
      appBar: ResponsiveAppBar(
        context: context,
        title: context.l10n.allEntries,
        showMenu: true,
        onExport: () {
          final exportEntriesController =
              ExportEntriesController(currencyFormatter: currencyFormatter);

          exportEntriesController.onExport(context, copyOfAllEntries);
        },
      ),
      body: Center(
        child: SizedBox(
          width: context.largerThanMobile ? context.width * 0.3 : context.width,
          child: ListView(
            shrinkWrap: context.largerThanMobile ? true : false,
            children: copyOfAllEntries.map(_toEntryListTile).toList(),
          ),
        ),
      ),
    );
  }

  EntryListTile _toEntryListTile(entry) {
    return EntryListTile(entry: entry, currencyFormatter: currencyFormatter);
  }
}
