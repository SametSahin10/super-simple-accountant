import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/models/entry.dart';

class EntryListTile extends StatelessWidget {
  final Entry entry;
  final NumberFormat currencyFormatter;

  const EntryListTile({
    super.key,
    required this.entry,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final descriptionExists =
        (entry.description != null) && entry.description?.isEmpty == false;

    final description =
        descriptionExists ? entry.description : "No description";

    final amountPrefixSign = entry.amount.isNegative ? "" : "+";

    final amountText =
        amountPrefixSign + currencyFormatter.format(entry.amount);

    return ListTile(
      title: Text(description!),
      trailing: Text(
        amountText,
        style: TextStyle(
          color: entry.amount.isNegative ? Colors.red : Colors.green,
          fontSize: 16,
        ),
      ),
    );
  }
}
