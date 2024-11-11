import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/utility_functions.dart';
import 'package:super_simple_accountant/widgets/entry_details_bottom_sheet.dart';

class EntryListTile extends ConsumerWidget {
  final Entry entry;

  const EntryListTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptionExists =
        (entry.description != null) && entry.description?.isEmpty == false;

    final description =
        descriptionExists ? entry.description : context.l10n.noDescription;

    final amountPrefixSign = entry.amount.isNegative ? "" : "+";

    final currencyFormatter = ref.watch(currencyFormatterProvider);

    final amountText =
        amountPrefixSign + currencyFormatter!.format(entry.amount);

    final fontSize = context.largerThanMobile ? 24.0 : 16.0;

    return Dismissible(
      key: Key(entry.createdAt.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) {
        return showConfirmDeletingEntryDialog(context);
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          final entriesStateNotifier =
              ref.read(entriesStateNotifierProvider.notifier);

          entriesStateNotifier.deleteEntry(entry);
        }
      },
      child: ListTile(
        title: Text(
          description!,
          style: TextStyle(fontSize: fontSize),
        ),
        trailing: Text(
          amountText,
          style: TextStyle(
            color: entry.amount.isNegative ? Colors.red : Colors.green,
            fontSize: fontSize,
          ),
        ),
        onTap: () {
          FirebaseAnalytics.instance.logEvent(
            name: 'entry_list_tile_tapped',
          );

          showModalBottomSheet(
            context: context,
            builder: (_) {
              return EntryDetailsBottomSheet(
                entry: entry,
                amountText: amountText,
              );
            },
          );
        },
      ),
    );
  }
}
