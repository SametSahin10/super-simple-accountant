import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/widgets/add_entry_fab.dart';
import 'package:super_simple_accountant/widgets/text_with_top_padding.dart';

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
          ),
      onPressed: () {
        FirebaseAnalytics.instance.logEvent(
          name: AnalyticsEvents.addEntryButtonPressed,
        );

        pushAddEntryScreen(context);
      },
      child: TextWithTopPadding(
        text: Text(
          context.l10n.addEntry,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
