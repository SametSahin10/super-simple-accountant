import 'package:flutter/material.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/default_categories.dart';
import 'package:super_simple_accountant/models/entry.dart';

import 'package:intl/intl.dart';
import 'package:super_simple_accountant/widgets/delete_entry_button.dart';

class EntryDetailsBottomSheet extends StatelessWidget {
  final Entry entry;
  final String amountText;

  const EntryDetailsBottomSheet({
    super.key,
    required this.entry,
    required this.amountText,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = formatter.format(entry.createdAt);

    return Container(
      width: double.infinity,
      height: 280,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.description != null && entry.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                entry.description!,
                style: const TextStyle(fontSize: 22.0),
              ),
            ),
          Text(
            amountText,
            style: TextStyle(
              color: entry.amount.isNegative ? Colors.red : Colors.green,
              fontSize: 22.0,
            ),
          ),
          if (entry.category != null)
            Builder(builder: (context) {
              final categoryId = entry.category!.id;

              final icon = categoryIcons[categoryId];

              final categoryName =
                  getTranslatedCategoryName(context, categoryId);

              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  children: [
                    Icon(icon, color: primaryColor, size: 22),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        categoryName,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              );
            }),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Text(
              formattedDate,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          const Spacer(),
          DeleteEntryButton(
            entry: entry,
            onDelete: () {
              // Hide the bottom sheet.
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
