import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:super_simple_accountant/admob_config.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/navigation.dart';
import 'package:super_simple_accountant/screens/receipt_confirmation_screen.dart';
import 'package:super_simple_accountant/services/image_compressor_service.dart';
import 'package:super_simple_accountant/services/receipt_scanner_service.dart';
import 'package:super_simple_accountant/state/entitlement_notifier.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/add_entry_fab.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/bottom_sheets/choose_image_source_bottom_sheet.dart';
import 'package:super_simple_accountant/widgets/brief_entries_widget.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';
import 'package:super_simple_accountant/widgets/syncing_entries_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(entitlementNotifierProvider);

    return Scaffold(
      appBar: ResponsiveAppBar(
        context: context,
        title: entitlement == Entitlement.plus
            ? '${context.l10n.appTitle} Plus'
            : context.l10n.appTitle,
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
                name: AnalyticsEvents.addEntryButtonPressed,
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
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final entitlement = ref.read(entitlementNotifierProvider);

    if (entitlement == Entitlement.standard) {
      // Launch the in-app purchase flow
      final paywallResult = await RevenueCatUI.presentPaywall();

      if (paywallResult != PaywallResult.purchased) return;

      final userId = await pushAuthScreen(navigator);

      debugPrint('User ID: $userId');
    }

    FirebaseAnalytics.instance.logEvent(
      name: AnalyticsEvents.scanReceiptButtonPressed,
    );

    try {
      final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => const ChooseImageSourceBottomSheet(),
      );

      if (imageSource == null) return;

      final scanner = ReceiptScannerService();
      final image = await scanner.captureReceipt(imageSource);

      if (image == null) return;
      if (!context.mounted) return;

      final file = File(image.path);
      final fileBytes = await file.readAsBytes();

      final compressedImage =
          await ImageCompressorService().compressFile(fileBytes);

      context.showProgressDialog(text: 'Analyzing receipt...');
      final receiptData = await scanner.processReceipt(compressedImage);
      navigator.pop();

      if (receiptData == null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to analyze receipt')),
        );

        return;
      }

      if (!context.mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("An error occurred."),
          ),
        );

        FirebaseCrashlytics.instance.recordError(
          Exception(
            "Receipt has been analyzed but the results cannot be shown "
            "because the context is not mounted.",
          ),
          StackTrace.current,
        );

        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return ReceiptConfirmationScreen(
              receiptAnalysisResult: receiptData,
              imagePath: image.path,
              imageInBytes: compressedImage,
            );
          },
        ),
      );
    } catch (err) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to scan receipt'),
        ),
      );
    }
  }
}

class _HomeScreenBody extends ConsumerWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);

    if (entriesStateModel.widgetState == WidgetState.loading) {
      return const Center(child: CircularProgressIndicator());
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
            const SizedBox(height: 32),
            const SyncingEntriesWidget(),
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
