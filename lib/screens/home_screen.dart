import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:super_simple_accountant/admob_config.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/screens/receipt_confirmation_screen.dart';
import 'package:super_simple_accountant/services/receipt_scanner_service.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Add Basic Entry',
            onTap: () {
              FirebaseAnalytics.instance.logEvent(
                name: 'add_entry_button_pressed',
              );

              pushAddEntryScreen(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.receipt),
            label: 'Scan Receipt',
            onTap: () => _handleReceiptScan(context),
          ),
        ],
        child: Image.asset(Assets.fountainPen, scale: 4.2),
      ),
    );
  }

  Future<void> _handleReceiptScan(BuildContext context) async {
    final scanner = ReceiptScannerService();
    final image = await scanner.captureReceipt();

    if (image == null) return;

    if (!context.mounted) return;

    final receiptData = await scanner.processReceipt(image);
    if (receiptData == null) return;

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ReceiptConfirmationScreen(
            receiptAnalysisResult: receiptData,
            imagePath: image.path,
          );
        },
      ),
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
    final formattedCurrency = currencyFormatter!.format(netAmount);

    return Center(
      child: SizedBox(
        width: context.largerThanMobile ? context.width * 0.3 : context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BannerAdWidget(
              adUnitId: getAdUnitId(AdUnit.homeScreenBanner),
            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
