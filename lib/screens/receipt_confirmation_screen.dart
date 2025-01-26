import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/category.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/models/receipt/receipt_analysis_result.dart';
import 'package:super_simple_accountant/navigation.dart';
import 'package:super_simple_accountant/repositories/file_storage_repository.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class ReceiptConfirmationScreen extends ConsumerStatefulWidget {
  final ReceiptAnalysisResult receiptAnalysisResult;
  final String imagePath;
  final Uint8List imageInBytes;

  const ReceiptConfirmationScreen({
    super.key,
    required this.receiptAnalysisResult,
    required this.imagePath,
    required this.imageInBytes,
  });

  @override
  ConsumerState<ReceiptConfirmationScreen> createState() =>
      _ReceiptConfirmationScreenState();
}

class _ReceiptConfirmationScreenState
    extends ConsumerState<ReceiptConfirmationScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.receiptAnalysisResult.total.toStringAsFixed(2),
    );
    _merchantController = TextEditingController(
      text: widget.receiptAnalysisResult.merchant,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  TextField(
                    controller: _merchantController,
                    decoration: const InputDecoration(
                      labelText: 'Merchant',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 18),
                  CategoryDropdown(
                    initialCategory: widget.receiptAnalysisResult.category,
                    onCategorySelected: (selectedCategory) {
                      setState(() {
                        _selectedCategory = selectedCategory;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onConfirmButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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

  Future<void> _onConfirmButtonPressed() async {
    final navigator = Navigator.of(context);

    // Check if user is authenticated
    final user = await ref.watch(userStreamProvider.future);
    String? userId = user?.uid;

    if (userId == null) {
      userId = await pushAuthScreen(navigator);
      if (userId == null) return;
    }

    _saveEntry(userId: userId, navigator: navigator);
  }

  Future<void> _saveEntry({
    required String userId,
    required NavigatorState navigator,
  }) async {
    context.showProgressDialog(text: 'Saving entry...');

    final fileStorageRepository = FileStorageRepository();

    final imageUrl = await fileStorageRepository.uploadFile(
      userId: userId,
      file: widget.imageInBytes,
    );

    debugPrint('imageUrl: $imageUrl');

    final amount = double.tryParse(_amountController.text) ?? 0;

    final entry = Entry(
      id: const Uuid().v4(),
      userId: userId,
      amount: -amount,
      createdAt: DateTime.now(),
      description: _merchantController.text,
      category: _selectedCategory,
      source: EntrySource.receipt(
        imagePath: widget.imagePath,
        imageUrl: imageUrl,
        merchantName: _merchantController.text,
      ),
    );

    ref.read(entriesStateNotifierProvider.notifier).addEntry(entry);

    // Hide progress dialog
    navigator.pop();

    navigator.pop();
  }
}
