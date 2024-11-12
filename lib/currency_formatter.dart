import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  final Locale locale;
  final NumberFormat currencyFormatter;

  const CurrencyFormatter({
    required this.locale,
    required this.currencyFormatter,
  });

  String format(double netAmount, {bool replaceTurkishCurrencySymbol = true}) {
    final formattedCurrency = currencyFormatter.format(netAmount);

    final currencyIsTL = formattedCurrency.contains("TL");
    final languageIsTurkish = locale.languageCode == "tr";

    if (languageIsTurkish && currencyIsTL && replaceTurkishCurrencySymbol) {
      return formattedCurrency.replaceFirst("TL", "₺");
    } else {
      return formattedCurrency;
    }
  }
}
