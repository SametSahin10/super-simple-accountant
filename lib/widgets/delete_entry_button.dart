import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';

class DeleteEntryButton extends ConsumerWidget {
  final Entry entry;
  final VoidCallback onDelete;

  const DeleteEntryButton({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(entriesStateNotifierProvider.notifier).deleteEntry(entry);
        onDelete();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text(
        context.l10n.deleteEntry,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }
}
