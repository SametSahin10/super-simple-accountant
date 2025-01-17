import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/extensions.dart';

class ConfirmDeletingEntryDialog extends StatelessWidget {
  const ConfirmDeletingEntryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.deleteEntryDialogTitle),
      content: Text(
        context.l10n.deleteEntryDialogContent,
        style: const TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            FirebaseAnalytics.instance.logEvent(
              name: AnalyticsEvents.cancelDeletingEntryDialog,
            );
            Navigator.of(context).pop(false);
          },
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            FirebaseAnalytics.instance.logEvent(
              name: AnalyticsEvents.confirmDeletingEntryDialog,
            );
            Navigator.of(context).pop(true);
          },
          child: Text(context.l10n.deleteEntry),
        ),
      ],
    );
  }
}
