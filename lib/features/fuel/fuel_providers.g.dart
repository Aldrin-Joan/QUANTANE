// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fuelHistory)
final fuelHistoryProvider = FuelHistoryProvider._();

final class FuelHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FuelEntry>>,
          List<FuelEntry>,
          Stream<List<FuelEntry>>
        >
    with $FutureModifier<List<FuelEntry>>, $StreamProvider<List<FuelEntry>> {
  FuelHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fuelHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fuelHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<FuelEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FuelEntry>> create(Ref ref) {
    return fuelHistory(ref);
  }
}

String _$fuelHistoryHash() => r'd0105d46cc21b24de0d1e1553916e52f15c9c80c';
