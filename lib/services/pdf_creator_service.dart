import 'package:super_simple_accountant/currency_formatter.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/assets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PdfCreatorService {
  final CurrencyFormatter currencyFormatter;

  const PdfCreatorService({required this.currencyFormatter});

  Future<Uint8List> createPdf(List<Entry> entries) async {
    final pdf = await _generatePdf(entries);
    return pdf.save();
  }

  Future<pw.Document> _generatePdf(List<Entry> entries) async {
    final pdf = pw.Document();
    final appIcon = kIsWeb ? null : await _loadAppIcon();

    final netAmount = entries.fold(0.0, (sum, entry) => sum + entry.amount);

    final formattedCurrency = currencyFormatter.format(
      netAmount,
      replaceTurkishCurrencySymbol: false,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (!kIsWeb) _buildHeaderRow(appIcon!),
              pw.SizedBox(height: 20),
              _buildHeader(),
              pw.SizedBox(height: 20),
              ...entries.map(_buildEntryRow),
              pw.Divider(),
              _buildNetAmount(formattedCurrency),
              pw.Spacer(),
              _buildDownloadLink(),
              pw.SizedBox(height: 10),
              _buildWebsiteLink(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<pw.MemoryImage> _loadAppIcon() async {
    final appIconBytes =
        (await rootBundle.load(Assets.appIconRounded)).buffer.asUint8List();
    return pw.MemoryImage(appIconBytes);
  }

  pw.Widget _buildHeaderRow(pw.MemoryImage appIcon) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        _buildAppIconContainer(appIcon),
        pw.SizedBox(width: 12),
        _buildAppTitle(),
      ],
    );
  }

  pw.Widget _buildAppIconContainer(pw.MemoryImage appIcon) {
    return pw.Container(
      height: 40,
      width: 40,
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        image: pw.DecorationImage(image: appIcon),
      ),
    );
  }

  pw.Widget _buildAppTitle() {
    return pw.Text(
      'Super Simple Accountant',
      style: const pw.TextStyle(fontSize: 18),
    );
  }

  pw.Widget _buildHeader() {
    return pw.Header(
      level: 0,
      child: pw.Text('Entries', style: const pw.TextStyle(fontSize: 24)),
    );
  }

  pw.Widget _buildDownloadLink() {
    return pw.Center(
      child: pw.UrlLink(
        destination:
            'https://play.google.com/store/apps/details?id=com.super_simple_accountant.app&pli=1',
        child: pw.Text(
          'Download Now!',
          style: const pw.TextStyle(
            color: PdfColors.blue,
            decoration: pw.TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildWebsiteLink() {
    return pw.Center(
      child: pw.UrlLink(
        destination: 'https://simpleaccountant.app',
        child: pw.Text(
          'simpleaccountant.app',
          style: const pw.TextStyle(
            color: PdfColors.blue,
            decoration: pw.TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildEntryRow(Entry entry) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildEntryDescription(entry),
          _buildEntryAmount(entry),
        ],
      ),
    );
  }

  pw.Widget _buildNetAmount(String formattedCurrency) {
    return pw.Row(
      children: [
        pw.Spacer(),
        pw.Text(
          formattedCurrency,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildEntryDescription(Entry entry) {
    final description = entry.description;
    final entryExists = description != null && description.isNotEmpty;

    return pw.Text(
      entryExists ? description : 'No description',
      style: const pw.TextStyle(fontSize: 14),
    );
  }

  pw.Widget _buildEntryAmount(Entry entry) {
    final amountPrefixSign = entry.amount.isNegative ? "" : "+";

    final formattedCurrency = currencyFormatter.format(
      entry.amount,
      replaceTurkishCurrencySymbol: false,
    );

    final amountText = amountPrefixSign + formattedCurrency;

    return pw.Text(
      amountText,
      style: pw.TextStyle(
        fontSize: 14,
        color: entry.amount.isNegative ? PdfColors.red : PdfColors.green,
      ),
    );
  }
}
