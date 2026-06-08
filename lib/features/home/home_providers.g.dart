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
          Stream<HomeSummary?>
        >
    with $FutureModifier<HomeSummary?>, $StreamProvider<HomeSummary?> {
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
  $StreamProviderElement<HomeSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<HomeSummary?> create(Ref ref) {
    return homeSummary(ref);
  }
}

String _$homeSummaryHash() => r'1e7cdca6b208c08107e32853eeb04ba8b6ac1c68';

@ProviderFor(quickStats)
final quickStatsProvider = QuickStatsProvider._();

final class QuickStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<QuickStats?>,
          QuickStats?,
          Stream<QuickStats?>
        >
    with $FutureModifier<QuickStats?>, $StreamProvider<QuickStats?> {
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
  $StreamProviderElement<QuickStats?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<QuickStats?> create(Ref ref) {
    return quickStats(ref);
  }
}

String _$quickStatsHash() => r'08be98b6812019a13b5aef6a870456f905c875d8';
