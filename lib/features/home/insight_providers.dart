import 'package:quantane/features/home/home_providers.dart';
import 'package:quantane/features/shared/utils/insight_engine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insight_providers.g.dart';

@riverpod
Future<List<Insight>> insights(Ref ref) async {
  final summary = await ref.watch(homeSummaryProvider.future);
  if (summary == null) return [];

  return InsightEngine.generateInsights(
    currentMileage: summary.avgMileageMonth,
    lastMileage: 26.5, // Mock last period
    totalSpend: summary.totalSpendMonth,
  );
}
