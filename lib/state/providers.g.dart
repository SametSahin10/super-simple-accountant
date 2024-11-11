// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currencyFormatterHash() => r'6d0a7486ae60b554bcf76cce564cdba3ea1d3020';

/// See also [currencyFormatter].
@ProviderFor(currencyFormatter)
final currencyFormatterProvider = AutoDisposeProvider<NumberFormat?>.internal(
  currencyFormatter,
  name: r'currencyFormatterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyFormatterHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrencyFormatterRef = AutoDisposeProviderRef<NumberFormat?>;
String _$addEntryScreenModelHash() =>
    r'e143cd6459b16e772dfe7a6e18620af2af5ab9d9';

/// See also [addEntryScreenModel].
@ProviderFor(addEntryScreenModel)
final addEntryScreenModelProvider =
    AutoDisposeProvider<AddEntryScreenModel>.internal(
  addEntryScreenModel,
  name: r'addEntryScreenModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addEntryScreenModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddEntryScreenModelRef = AutoDisposeProviderRef<AddEntryScreenModel>;
String _$selectedCategoryNotifierHash() =>
    r'54eb168307fe5e94caf7c0e950e51e6341e090ae';

/// See also [SelectedCategoryNotifier].
@ProviderFor(SelectedCategoryNotifier)
final selectedCategoryNotifierProvider =
    AutoDisposeNotifierProvider<SelectedCategoryNotifier, Category?>.internal(
  SelectedCategoryNotifier.new,
  name: r'selectedCategoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategoryNotifier = AutoDisposeNotifier<Category?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
