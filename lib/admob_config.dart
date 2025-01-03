import 'dart:io';

import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';

String getAdUnitId(AdUnit adUnit) {
  switch (adUnit) {
    case AdUnit.homeScreenBanner:
      if (Platform.isIOS) {
        return homeScreenBannerAdIdOnIos;
      } else if (Platform.isAndroid) {
        return homeScreenBannerAdIdOnAndroid;
      } else {
        throw Exception("Cannot get ad unit id. Unsupported platform.");
      }
    case AdUnit.addEntryScreenBanner:
      if (Platform.isIOS) {
        return addEntryScreenBannerAdIdOnIos;
      } else if (Platform.isAndroid) {
        return addEntryScreenBannerAdIdOnAndroid;
      } else {
        throw Exception("Cannot get ad unit id. Unsupported platform.");
      }
    case AdUnit.reportsScreenBanner:
      if (Platform.isIOS) {
        return reportsScreenBannerAdIdOnIos;
      } else if (Platform.isAndroid) {
        return reportsScreenBannerAdIdOnAndroid;
      } else {
        throw Exception("Cannot get ad unit id. Unsupported platform.");
      }
  }
}
