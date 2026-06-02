// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeSummary)
final homeSummaryProvider = HomeSummaryProvider._();

final class HomeSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeSummary?>,
          HomeSummary?,
          FutureOr<HomeSummary?>
        >
    with $FutureModifier<HomeSummary?>, $FutureProvider<HomeSummary?> {
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
  $FutureProviderElement<HomeSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeSummary?> create(Ref ref) {
    return homeSummary(ref);
  }
}

String _$homeSummaryHash() => r'39e6c5edbfdbd01798832111e5d5f1552743455f';

@ProviderFor(quickStats)
final quickStatsProvider = QuickStatsProvider._();

final class QuickStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<QuickStats?>,
          QuickStats?,
          FutureOr<QuickStats?>
        >
    with $FutureModifier<QuickStats?>, $FutureProvider<QuickStats?> {
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
  $FutureProviderElement<QuickStats?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<QuickStats?> create(Ref ref) {
    return quickStats(ref);
  }
}

String _$quickStatsHash() => r'936ea16ba3b01df0e6cb6a09cc6da70da9251e01';
