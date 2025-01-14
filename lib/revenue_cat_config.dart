import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> configureRevenueCat({String? userId}) async {
  if (kDebugMode) await Purchases.setLogLevel(LogLevel.debug);

  final apiKey = _getApiKey();

  final configuration = PurchasesConfiguration(apiKey)
    ..appUserID = userId
    ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  await Purchases.configure(configuration);
}

String _getApiKey() {
  final androidApiKey = dotenv.env['REVENUECAT_ANDROID_API_KEY'];
  final iosApiKey = dotenv.env['REVENUECAT_IOS_API_KEY'];

  if (Platform.isAndroid) {
    return androidApiKey!;
  } else if (Platform.isIOS) {
    return iosApiKey!;
  } else {
    throw Exception('Unsupported platform');
  }
}
