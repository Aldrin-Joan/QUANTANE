import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/features/home/home_providers.dart';
import 'package:quantane/features/home/widgets/hero_summary_card.dart';
import 'package:quantane/features/home/widgets/quick_stats_grid.dart';
import 'package:quantane/features/home/widgets/weekly_spend_chart.dart';
import 'package:quantane/features/home/widgets/insight_banner.dart';
import 'package:quantane/features/shared/widgets/section_header.dart';
import 'package:quantane/features/shared/widgets/vehicle_selector_chip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(homeSummaryProvider);
    final statsAsync = ref.watch(quickStatsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Quantane'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: VehicleSelectorChip(),
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
                    : const _EmptySectionCard(
                        title: 'Quick Stats',
                        message:
                            'No stats yet. Add trips and fuel entries to see mileage, distance, speed, and cost summaries.',
                      ),
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
              ),
              const SectionHeader(title: 'Smart Insights'),
              const InsightBanner(),
              const SectionHeader(title: 'Mileage & Speed'),
              const SpeedMileageCarousel(),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  final String title;
  final String message;

  const _EmptySectionCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF121821),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E2A3A)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.insights_outlined,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title unavailable',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFF1F5F9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
