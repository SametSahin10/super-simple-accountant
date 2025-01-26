import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_simple_accountant/constants.dart';
import 'package:super_simple_accountant/enums.dart';

part 'entitlement_notifier.g.dart';

@riverpod
class EntitlementNotifier extends _$EntitlementNotifier {
  @override
  Entitlement build() {
    ref.onDispose(() {
      Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdate);
    });

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

    return Entitlement.standard;
  }

  void _onCustomerInfoUpdate(CustomerInfo info) {
    state = _getEntitlementFromInfo(info);
  }

  void setEntitlement(Entitlement entitlement) {
    state = entitlement;
  }

  Entitlement _getEntitlementFromInfo(CustomerInfo info) {
    return info.entitlements.active.containsKey(plusEntitlementId)
        ? Entitlement.plus
        : Entitlement.standard;
  }
}
