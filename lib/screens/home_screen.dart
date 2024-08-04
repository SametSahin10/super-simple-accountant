import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/add_entry_button.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/brief_entries_widget.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';

import 'add_entry_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    return Scaffold(
      appBar: ResponsiveAppBar(
        context: context,
        title: context.l10n.appTitle,
        showAppIcon: context.largerThanMobile ? true : false,
      ),
      body: _HomeScreenBody(currencyFormatter: currencyFormatter!),
      floatingActionButton:
          context.largerThanMobile ? null : const _FloatingActionButton(),
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
    final formattedCurrency = _getFormattedCurrency(context, netAmount);

    return Center(
      child: SizedBox(
        width: context.largerThanMobile ? context.width * 0.3 : context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BannerAdWidget(adUnitId: homeScreenBannerAdId),
            Expanded(
              child: Column(
                mainAxisAlignment: context.largerThanMobile
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    formattedCurrency,
                    style: TextStyle(
                      fontSize: context.largerThanMobile ? 64 : 48,
                    ),
                  ),
                  if (entriesStateModel.entries.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: BriefEntriesWidget(
                        currencyFormatter: currencyFormatter,
                      ),
                    ),
                  if (context.largerThanMobile)
                    const Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: AddEntryButton(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedCurrency(BuildContext context, double netAmount) {
    final formattedCurrency = currencyFormatter.format(netAmount);
    final local = Localizations.localeOf(context);

    if (local.languageCode == "tr" && formattedCurrency.startsWith("TL")) {
      final currencyWithoutSymbol = formattedCurrency.substring(2);
      return "₺$currencyWithoutSymbol";
    } else {
      return formattedCurrency;
    }
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      onPressed: () => pushAddEntryScreen(context),
      child: Image.asset(Assets.fountainPen, scale: 3.8),
    );
  }
}

void pushAddEntryScreen(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddEntryScreen()),
  );
}
