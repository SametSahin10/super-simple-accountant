import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:super_simple_accountant/admob_config.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/category.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/category_dropdown.dart';
import 'package:super_simple_accountant/widgets/entry_action_button.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';
import 'package:uuid/uuid.dart';

class AddEntryScreen extends ConsumerWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addEntryScreenModel = ref.watch(addEntryScreenModelProvider);

    final amountController = addEntryScreenModel.amountController;
    final descriptionController = addEntryScreenModel.descriptionController;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ResponsiveAppBar(
          context: context,
          title: context.l10n.addEntry,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: context.largerThanMobile
                  ? context.width * 0.3
                  : context.width,
              child: ListView(
                children: [
                  BannerAdWidget(
                    adUnitId: getAdUnitId(AdUnit.addEntryScreenBanner),
                  ),
                  const SizedBox(height: 70),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 32.0),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: context.l10n.amountTextFieldHint,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller: descriptionController,
                          style: const TextStyle(fontSize: 28.0),
                          decoration: InputDecoration(
                            labelText: context.l10n.descriptionTextFieldHint,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CategoryDropdown(
                        onCategorySelected: (selectedCategory) {
                          final notifier = ref
                              .read(selectedCategoryNotifierProvider.notifier);

                          notifier.setSelectedCategory(selectedCategory);
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 36, bottom: 8),
                    child: _IncreaseAndDecreaseButtons(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncreaseAndDecreaseButtons extends ConsumerWidget {
  const _IncreaseAndDecreaseButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        EntryActionButton(
          iconPath: Assets.minus,
          color: Colors.red,
          onTap: () {
            _decreaseAmount(
              context: context,
              ref: ref,
              selectedCategory: selectedCategory,
            );
          },
        ),
        EntryActionButton(
          iconPath: Assets.plus,
          color: Colors.green,
          onTap: () {
            _increaseAmount(
              context: context,
              ref: ref,
              selectedCategory: selectedCategory,
            );
          },
        ),
      ],
    );
  }

  void _increaseAmount({
    required BuildContext context,
    required WidgetRef ref,
    required Category? selectedCategory,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'increase_amount_button_pressed',
    );

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
      id: const Uuid().v4(),
      source: EntrySource.basic(),
      amount: currentAmount.abs(),
      description: description,
      category: selectedCategory,
      createdAt: DateTime.now(),
    );

    ref.read(entriesStateNotifierProvider.notifier).addEntry(entry);

    Navigator.of(context).pop();

    if (askForInAppReview) _requestInAppReviewAfterDelay();
  }

  void _decreaseAmount({
    required BuildContext context,
    required WidgetRef ref,
    required Category? selectedCategory,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'decrease_amount_button_pressed',
    );

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
      id: const Uuid().v4(),
      source: EntrySource.basic(),
      amount: -currentAmount.abs(),
      description: description,
      category: selectedCategory,
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
