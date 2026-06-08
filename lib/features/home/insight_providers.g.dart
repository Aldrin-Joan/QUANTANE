// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(insights)
final insightsProvider = InsightsProvider._();

final class InsightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Insight>>,
          List<Insight>,
          FutureOr<List<Insight>>
        >
    with $FutureModifier<List<Insight>>, $FutureProvider<List<Insight>> {
  InsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsHash();

  @$internal
  @override
  $FutureProviderElement<List<Insight>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Insight>> create(Ref ref) {
    return insights(ref);
  }
}

String _$insightsHash() => r'1ed2381041c567135fcc81a4bf73118805eb5d64';
