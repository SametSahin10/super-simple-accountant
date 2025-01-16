import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/screens/all_entries_screen.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/widgets/entry_list_tile.dart';

class BriefEntriesWidget extends ConsumerWidget {
  const BriefEntriesWidget({super.key});

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

    const showMoreWidget = _ShowMoreWidget();

    return Column(
      children: [...entryListTiles, if (showShowMoreWidget) showMoreWidget],
    );
  }

  EntryListTile _toEntryListTile(entry) {
    return EntryListTile(entry: entry);
  }
}

class _ShowMoreWidget extends StatelessWidget {
  const _ShowMoreWidget();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        FirebaseAnalytics.instance.logEvent(
          name: AnalyticsEvents.seeMoreEntriesButtonPressed,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AllEntriesScreen(),
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
