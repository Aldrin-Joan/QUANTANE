import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/shared/providers/vehicle_providers.dart';
import 'package:quantane/features/home/home_providers.dart';
import 'package:quantane/features/home/widgets/hero_summary_card.dart';
import 'package:quantane/features/home/widgets/quick_stats_grid.dart';
import 'package:quantane/features/home/widgets/weekly_spend_chart.dart';
import 'package:quantane/features/home/widgets/insight_banner.dart';
import 'package:quantane/features/shared/widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(homeSummaryProvider);
    final statsAsync = ref.watch(quickStatsProvider);
    final activeVehicleAsync = ref.watch(activeVehicleDetailsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Quantane'),
            actions: [
              activeVehicleAsync.when(
                data: (vehicle) => vehicle != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Chip(
                          label: Text(vehicle.name),
                          backgroundColor: AppColors.primaryMuted,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(fontSize: 12, color: AppColors.primaryColor),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                    : const SizedBox(),
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              summaryAsync.when(
                data: (summary) => summary != null 
                    ? HeroSummaryCard(summary: summary) 
                    : const SizedBox(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
              const SectionHeader(title: 'Quick Stats'),
              statsAsync.when(
                data: (stats) => stats != null 
                    ? QuickStatsGrid(stats: stats) 
                    : const SizedBox(),
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
              ),
              const SectionHeader(title: 'Smart Insights'),
              const InsightBanner(),
              const SectionHeader(title: 'This Week'),
              const WeeklySpendChart(),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }
}
