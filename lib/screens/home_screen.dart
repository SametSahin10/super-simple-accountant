import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/add_entry_button.dart';
import 'package:super_simple_accountant/widgets/add_entry_fab.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/brief_entries_widget.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(
        context: context,
        title: context.l10n.appTitle,
        showAppIcon: context.largerThanMobile ? true : false,
      ),
      body: const _HomeScreenBody(),
      floatingActionButton:
          context.largerThanMobile ? null : const AddEntryFab(),
    );
  }
}

class _HomeScreenBody extends ConsumerWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);

    if (entriesStateModel.widgetState == WidgetState.loading) {
      return const CircularProgressIndicator();
    }

    final entriesStateNotifier =
        ref.watch(entriesStateNotifierProvider.notifier);

    final netAmount = entriesStateNotifier.getNetAmount();

    final currencyFormatter = ref.watch(currencyFormatterProvider);

    final formattedCurrency = _getFormattedCurrency(
      context: context,
      netAmount: netAmount,
      currencyFormatter: currencyFormatter!,
    );

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
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: BriefEntriesWidget(),
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

  String _getFormattedCurrency({
    required BuildContext context,
    required double netAmount,
    required NumberFormat currencyFormatter,
  }) {
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
