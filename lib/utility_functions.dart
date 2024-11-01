import 'package:flutter/material.dart';
import 'package:super_simple_accountant/dialogs/confirm_deleting_entry_dialog.dart';

Future<bool?> showConfirmDeletingEntryDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const ConfirmDeletingEntryDialog(),
  );
}
