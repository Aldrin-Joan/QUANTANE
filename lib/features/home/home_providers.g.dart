// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeMetrics)
final homeMetricsProvider = HomeMetricsProvider._();

final class HomeMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeMetricsSnapshot?>,
          HomeMetricsSnapshot?,
          Stream<HomeMetricsSnapshot?>
        >
    with
        $FutureModifier<HomeMetricsSnapshot?>,
        $StreamProvider<HomeMetricsSnapshot?> {
  HomeMetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeMetricsHash();

  @$internal
  @override
  $StreamProviderElement<HomeMetricsSnapshot?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<HomeMetricsSnapshot?> create(Ref ref) {
    return homeMetrics(ref);
  }
}

String _$homeMetricsHash() => r'4dd1c8ede48dd8db5af2e33319c659412d191ab2';

@ProviderFor(homeSummary)
final homeSummaryProvider = HomeSummaryProvider._();

final class HomeSummaryProvider
    extends $FunctionalProvider<HomeSummary?, HomeSummary?, HomeSummary?>
    with $Provider<HomeSummary?> {
  HomeSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSummaryHash();

  @$internal
  @override
  $ProviderElement<HomeSummary?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeSummary? create(Ref ref) {
    return homeSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeSummary? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeSummary?>(value),
    );
  }
}

String _$homeSummaryHash() => r'ddfa11e0db089dd9a3e20e6797e10ea4437e0d63';

@ProviderFor(quickStats)
final quickStatsProvider = QuickStatsProvider._();

final class QuickStatsProvider
    extends $FunctionalProvider<QuickStats?, QuickStats?, QuickStats?>
    with $Provider<QuickStats?> {
  QuickStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickStatsHash();

  @$internal
  @override
  $ProviderElement<QuickStats?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuickStats? create(Ref ref) {
    return quickStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickStats? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickStats?>(value),
    );
  }
}

String _$quickStatsHash() => r'c65f0b17cf02ead363418ac0e2fc07e5512465fb';
