import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/widgets/add_entry_button.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/brief_entries_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  NumberFormat? currencyFormatter;

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
      body: _HomeScreenBody(currencyFormatter: currencyFormatter!),
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

    final currencyIsTL = formattedCurrency.contains("TL");
    final replaceCurrencySymbol = local.languageCode == "tr" && currencyIsTL;

    if (replaceCurrencySymbol) {
      return formattedCurrency.replaceFirst("TL", "₺");
    } else {
      return formattedCurrency;
    }
  }
}
