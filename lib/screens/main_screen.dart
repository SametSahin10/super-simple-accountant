import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/screens/about_screen.dart';
import 'package:super_simple_accountant/screens/home_screen.dart';
import 'package:super_simple_accountant/screens/reports_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const ReportsScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarItemTap,
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
    );
  }

  void _onBottomNavBarItemTap(index) {
    _logBottomNavBarItemTap(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  void _logBottomNavBarItemTap(index) {
    String bottomTabName;

    switch (index) {
      case 0:
        bottomTabName = "home";
        break;
      case 1:
        bottomTabName = "reports";
        break;
      case 2:
        bottomTabName = "about";
        break;
      default:
        bottomTabName = "unknown";
    }

    FirebaseAnalytics.instance.logEvent(
      name: "bottom_navigation_bar_item_tapped",
      parameters: {"bottom_tab_name": bottomTabName},
    );
  }
}
