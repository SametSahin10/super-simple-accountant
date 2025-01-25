import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:super_simple_accountant/main.dart' as app;
import 'package:super_simple_accountant/screens/add_entry_screen.dart';
import 'package:super_simple_accountant/screens/home_screen.dart';
import 'package:super_simple_accountant/widgets/bottom_sheets/choose_image_source_bottom_sheet.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
      'Add basic entry',
      (tester) async {
        await app.main();
        await tester.pumpAndSettle();

        // Tap on the floating action button
        await _tapFloatingActionButton(tester);

        await tester.pump(const Duration(seconds: 1));

        final addBasicEntrySpeedDialChild = find.byKey(
          const ValueKey('add_basic_entry_speed_dial_child'),
        );

        await tester.tap(addBasicEntrySpeedDialChild);

        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        final addEntryScreen = find.byType(AddEntryScreen);
        expect(addEntryScreen, findsOne);

        final amountTextField = find.byKey(const ValueKey('amount_text_field'));
        await tester.enterText(amountTextField, '100');

        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        final descriptionTextField =
            find.byKey(const ValueKey('description_text_field'));
        await tester.enterText(descriptionTextField, 'PS5 Pro');

        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        // Scroll down
        final addEntryScreenListView =
            find.byKey(const ValueKey('add_entry_screen_list_view'));
        await tester.drag(addEntryScreenListView, const Offset(0, -500));

        await tester.pumpAndSettle();

        final decreaseAmountButton =
            find.byKey(const ValueKey('decrease_amount_button'));

        await tester.tap(decreaseAmountButton);

        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        final homeScreen = find.byType(HomeScreen);
        expect(homeScreen, findsOne);

        final netAmount = find.text('PS5 Pro');
        expect(netAmount, findsOne);
      },
    );

    testWidgets(
      'do not show the choose image source bottom sheet on standard plan',
      (tester) async {
        await app.main();
        await tester.pumpAndSettle();

        await _tapFloatingActionButton(tester);

        final scanReceiptSpeedDialChild = find.byKey(
          const ValueKey('scan_receipt_speed_dial_child'),
        );

        await tester.tap(scanReceiptSpeedDialChild);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));

        // Confirm that the modal bottom sheet is not shown
        final chooseImageSourceBottomSheet =
            find.byType(ChooseImageSourceBottomSheet);

        expect(chooseImageSourceBottomSheet, findsNothing);
      },
    );
  });
}

Future<void> _tapFloatingActionButton(WidgetTester tester) async {
  final speedDial = find.byType(SpeedDial);
  await tester.tap(speedDial);
  await tester.pumpAndSettle();
}
