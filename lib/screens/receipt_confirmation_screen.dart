import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_simple_accountant/models/category.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/models/receipt/receipt_analysis_result.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class ReceiptConfirmationScreen extends ConsumerStatefulWidget {
  final ReceiptAnalysisResult receiptAnalysisResult;
  final String imagePath;

  const ReceiptConfirmationScreen({
    super.key,
    required this.receiptAnalysisResult,
    required this.imagePath,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.file(
            File(widget.imagePath),
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _merchantController,
            decoration: const InputDecoration(
              labelText: 'Merchant',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CategoryDropdown(
            onCategorySelected: (selectedCategory) {
              setState(() {
                _selectedCategory = selectedCategory;
              });
            },
          ),
        ],
      ),
    );
  }

  void _saveEntry() {
    final entry = Entry(
      id: const Uuid().v4(),
      amount: double.tryParse(_amountController.text) ?? 0,
      createdAt: DateTime.now(),
      description: _merchantController.text,
      category: _selectedCategory,
      source: EntrySource.receipt(
        imagePath: widget.imagePath,
        merchantName: _merchantController.text,
      ),
    );

    ref.read(entriesStateNotifierProvider.notifier).addEntry(entry);

    Navigator.pop(context);
  }
}
