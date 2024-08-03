import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/entry_action_button.dart';

class AddEntryScreen extends ConsumerWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addEntryScreenModel = ref.watch(addEntryScreenModelProvider);

    final amountController = addEntryScreenModel.amountController;
    final descriptionController = addEntryScreenModel.descriptionController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BannerAdWidget(adUnitId: addEntryScreenBannerAdId),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 32.0),
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: _IncreaseAndDecreaseButtons(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncreaseAndDecreaseButtons extends ConsumerWidget {
  const _IncreaseAndDecreaseButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        EntryActionButton(
          iconPath: Assets.minus,
          color: Colors.red,
          onTap: () => _decreaseAmount(context, ref),
        ),
        EntryActionButton(
          iconPath: Assets.plus,
          color: Colors.green,
          onTap: () => _increaseAmount(context, ref),
        ),
      ],
    );
  }

  void _increaseAmount(BuildContext context, WidgetRef ref) {
    final addEntryScreenModel = ref.read(addEntryScreenModelProvider);

    final amountController = addEntryScreenModel.amountController;
    final descriptionController = addEntryScreenModel.descriptionController;

    if (amountController.text.isEmpty) return;

    final entriesStateModel = ref.read(entriesStateNotifierProvider);

    // The next entry will exceed the threshold.
    // Ask for review after adding the new entry.
    final askForInAppReview =
        entriesStateModel.entries.length == entryThresholdToRequestInAppReview;

    double currentAmount = double.tryParse(amountController.text) ?? 0.0;
    String description = descriptionController.text;

    final entry = Entry(
      amount: currentAmount.abs(),
      description: description,
      createdAt: DateTime.now(),
    );

    ref.read(entriesStateNotifierProvider.notifier).addEntry(entry);
    Navigator.of(context).pop();

    if (askForInAppReview) _requestInAppReviewAfterDelay();
  }

  void _decreaseAmount(BuildContext context, WidgetRef ref) {
    final addEntryScreenModel = ref.read(addEntryScreenModelProvider);

    final amountController = addEntryScreenModel.amountController;
    final descriptionController = addEntryScreenModel.descriptionController;

    if (amountController.text.isEmpty) return;

    final entriesStateModel = ref.read(entriesStateNotifierProvider);

    // The next entry will exceed the threshold.
    // Ask for review after adding the new entry.
    final askForInAppReview =
        entriesStateModel.entries.length == entryThresholdToRequestInAppReview;

    double currentAmount = double.tryParse(amountController.text) ?? 0.0;
    String description = descriptionController.text;

    final entry = Entry(
      amount: -currentAmount.abs(),
      description: description,
      createdAt: DateTime.now(),
    );

    ref.read(entriesStateNotifierProvider.notifier).addEntry(entry);
    Navigator.of(context).pop();

    if (askForInAppReview) _requestInAppReviewAfterDelay();
  }

  void _requestInAppReviewAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () async {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    });
  }
}
