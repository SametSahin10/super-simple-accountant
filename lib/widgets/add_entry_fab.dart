import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/screens/add_entry_screen.dart';

class AddEntryFab extends StatelessWidget {
  const AddEntryFab({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: primaryColor,
      onPressed: () {
        FirebaseAnalytics.instance.logEvent(
          name: 'add_entry_button_pressed',
        );

        pushAddEntryScreen(context);
      },
      icon: Image.asset(Assets.fountainPen, scale: 3.8),
    );
  }
}

void pushAddEntryScreen(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddEntryScreen()),
  );
}
