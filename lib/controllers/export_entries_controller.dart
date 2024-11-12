import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_simple_accountant/currency_formatter.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/services/pdf_creator_service.dart';
import 'package:universal_html/html.dart' as html;

class ExportEntriesController {
  final CurrencyFormatter currencyFormatter;

  const ExportEntriesController({required this.currencyFormatter});

  void onExport(BuildContext context, List<Entry> copyOfAllEntries) async {
    context.showProgressDialog(text: context.l10n.exportingEntries);

    try {
      final pdfInBytes = await _generatePdf(copyOfAllEntries);
      final fileName = _generateFileName();
      await _handleExport(context, pdfInBytes, fileName);
    } catch (e) {
      _handleError(context, e);
      return;
    }

    if (context.mounted) Navigator.pop(context);
  }

  Future<Uint8List> _generatePdf(List<Entry> entries) async {
    final pdfCreatorService =
        PdfCreatorService(currencyFormatter: currencyFormatter);
    return pdfCreatorService.createPdf(entries);
  }

  String _generateFileName() {
    return 'entries_${DateTime.now().toIso8601String().split('T')[0]}.pdf';
  }

  Future<void> _handleExport(
    BuildContext context,
    Uint8List pdfInBytes,
    String fileName,
  ) async {
    if (kIsWeb) {
      _handleWebExport(pdfInBytes, fileName);
    } else {
      await _handleMobileExport(context, pdfInBytes, fileName);
    }
  }

  void _handleWebExport(Uint8List pdfInBytes, String fileName) {
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = fileName;
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _handleMobileExport(
    BuildContext context,
    Uint8List pdfInBytes,
    String fileName,
  ) async {
    final pdfFile = XFile.fromData(
      pdfInBytes,
      name: fileName,
      mimeType: 'application/pdf',
    );

    if (context.mounted) {
      await Share.shareXFiles(
        [pdfFile],
        fileNameOverrides: [fileName],
      );
    }
  }

  void _handleError(BuildContext context, Object error) {
    debugPrint('Error generating PDF: $error');

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.exportEntriesError),
        ),
      );
    }
  }
}
