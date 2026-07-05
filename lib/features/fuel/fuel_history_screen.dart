// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/fuel/widgets/add_fuel_sheet.dart';
import 'package:quantane/features/fuel/widgets/fuel_entry_card.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/shared/widgets/section_header.dart';
import 'package:quantane/features/shared/widgets/vehicle_selector_chip.dart';

class FuelHistoryScreen extends ConsumerWidget {
  const FuelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(fuelHistoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(floating: true, title: Text('Fuel Log')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: _FuelHero(tracksAsync: historyAsync),
            ),
          ),
          const SliverToBoxAdapter(child: SectionHeader(title: 'Fuel Entries')),
          historyAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _FuelEmptyState(),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList.separated(
                  itemCount: entries.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) => FuelEntryCard(
                    entry: entries[index],
                    previousMileage: index + 1 < entries.length
                        ? entries[index + 1].mileage
                        : null,
                    onLongPress: () =>
                        _showEntryActions(context, ref, entries[index]),
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) => SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('Error loading fuel history: $e')),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddFuelSheet(),
          );
        },
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  void _showEntryActions(BuildContext context, WidgetRef ref, FuelEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cardColor,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Fuel entry actions',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose an action for this fuel entry.',
                  style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AddFuelSheet(existingEntry: entry),
                    );
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await ref.read(fuelRepositoryProvider).delete(entry.id);
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fuel entry deleted')),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.dangerColor.withValues(
                      alpha: 0.16,
                    ),
                    foregroundColor: AppColors.dangerColor,
                  ),
                  child: const Text('Delete'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FuelHero extends StatelessWidget {

  const _FuelHero({required this.tracksAsync});
  final AsyncValue<List<FuelEntry>> tracksAsync;

  @override
  Widget build(BuildContext context) {
    return tracksAsync.when(
      data: (entries) {
        final validEntries = entries
            .where((entry) => entry.mileage != null)
            .toList();
        final totalSpend = entries.fold<double>(
          0,
          (sum, entry) => sum + entry.fuelCost,
        );
        final totalLiters = validEntries.fold<double>(
          0,
          (sum, entry) => sum + entry.fuelLiters,
        );
        final totalDistance = _totalDistanceFromEntries(validEntries);
        final averageMileage = totalLiters > 0
            ? totalDistance / totalLiters
            : 0.0;

        return QuantaneCard(
          variant: QuantaneCardVariant.colored,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fuel tracking',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fuel history overview',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const VehicleSelectorChip(),
                ],
              ),
              const SizedBox(height: 22),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 18),
              Text(
                entries.isEmpty
                    ? 'Add your first fuel fill to track spend, liters, and mileage.'
                    : '${entries.length} fills • ₹ ${totalSpend.toStringAsFixed(0)} total • ${totalLiters.toStringAsFixed(1)} L',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _FuelHeroStat(
                      icon: Icons.payments_outlined,
                      label: 'Spend',
                      value: '₹ ${totalSpend.toStringAsFixed(0)}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FuelHeroStat(
                      icon: LucideIcons.droplets,
                      label: 'Liters',
                      value: totalLiters.toStringAsFixed(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FuelHeroStat(
                      icon: LucideIcons.gauge,
                      label: 'Mileage',
                      value: entries.any((entry) => entry.mileage != null)
                          ? '${averageMileage.toStringAsFixed(1)} KM/L'
                          : '--',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const QuantaneCard(
        variant: QuantaneCardVariant.colored,
        padding: EdgeInsets.all(20),
        child: SizedBox(
          height: 108,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
      error: (e, s) => QuantaneCard(
        variant: QuantaneCardVariant.colored,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Unable to load fuel history',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _totalDistanceFromEntries(List<FuelEntry> entries) {
  if (entries.isEmpty) {
    return 0;
  }

  return entries.fold<double>(
    0,
    (sum, entry) => sum + ((entry.mileage ?? 0.0) * entry.fuelLiters),
  );
}

class _FuelHeroStat extends StatelessWidget {

  const _FuelHeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuelEmptyState extends StatelessWidget {
  const _FuelEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: QuantaneCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.local_gas_station,
                    size: 30,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No fuel entries yet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use the add button to record your first fuel fill and start building spend and mileage history.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
