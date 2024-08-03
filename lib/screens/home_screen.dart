import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/brief_entries_widget.dart';

import 'add_entry_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final NumberFormat currencyFormatter;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);

    currencyFormatter = NumberFormat.simpleCurrency(
      locale: locale.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Simple Accountant'),
        centerTitle: true,
      ),
      body: _HomeScreenBody(currencyFormatter: currencyFormatter),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddEntryScreen,
        child: Image.asset(Assets.fountainPen, scale: 3.8, color: Colors.black),
      ),
    );
  }

  void _pushAddEntryScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEntryScreen()),
    );
  }
}

class _HomeScreenBody extends ConsumerWidget {
  final NumberFormat currencyFormatter;

  const _HomeScreenBody({required this.currencyFormatter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);

    if (entriesStateModel.widgetState == WidgetState.loading) {
      return const CircularProgressIndicator();
    }

    final entriesStateNotifier =
        ref.watch(entriesStateNotifierProvider.notifier);

    final netAmount = entriesStateNotifier.getNetAmount();

    final innerColumnChildren = <Widget>[
      Text(
        currencyFormatter.format(netAmount),
        style: const TextStyle(fontSize: 48.0),
      ),
    ];

    if (entriesStateModel.entries.isNotEmpty) {
      innerColumnChildren.addAll([
        BriefEntriesWidget(currencyFormatter: currencyFormatter),
      ]);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BannerAdWidget(adUnitId: homeScreenBannerAdId),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 6,
                  child: Text(
                    currencyFormatter.format(netAmount),
                    style: const TextStyle(fontSize: 48.0),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: BriefEntriesWidget(
                      currencyFormatter: currencyFormatter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
