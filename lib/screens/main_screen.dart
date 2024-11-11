import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/screens/about_screen.dart';
import 'package:super_simple_accountant/screens/home_screen.dart';
import 'package:super_simple_accountant/screens/reports_screen.dart';
import 'package:super_simple_accountant/state/providers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  NumberFormat? currencyFormatter;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);

    currencyFormatter ??=
        NumberFormat.simpleCurrency(locale: locale.toString());
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const ReportsScreen(),
      const AboutScreen(),
    ];

    return ProviderScope(
      overrides: [
        currencyFormatterProvider.overrideWithValue(currencyFormatter),
      ],
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: context.l10n.home_bottom_navigation_label,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart),
              label: context.l10n.reports_bottom_navigation_label,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info),
              label: context.l10n.about_bottom_navigation_label,
            ),
          ],
        ),
      ),
    );
  }
}
