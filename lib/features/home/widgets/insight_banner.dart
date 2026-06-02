import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/features/home/insight_providers.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/core/theme/colors.dart';

class InsightBanner extends ConsumerWidget {
  const InsightBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsProvider);

    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) return const SizedBox();
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                child: QuantaneCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(insight.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              insight.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              insight.description,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (e, s) => const SizedBox(),
    );
  }
}
