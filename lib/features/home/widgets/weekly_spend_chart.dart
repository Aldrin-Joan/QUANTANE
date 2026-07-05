import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/trips/trip_providers.dart';

class SpeedMileageCarousel extends ConsumerStatefulWidget {
  const SpeedMileageCarousel({super.key});

  @override
  ConsumerState<SpeedMileageCarousel> createState() =>
      _SpeedMileageCarouselState();
}

class _SpeedMileageCarouselState extends ConsumerState<SpeedMileageCarousel> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mileageAsync = ref.watch(fuelHistoryProvider);
    final speedAsync = ref.watch(tripHistoryProvider);

    return mileageAsync.when(
      data: (fuelEntries) => speedAsync.when(
        data: (trips) => _buildCarousel(fuelEntries, trips),
        loading: () => const SizedBox(height: 320),
        error: (error, stackTrace) => const SizedBox(height: 320),
      ),
      loading: () => const SizedBox(height: 320),
      error: (error, stackTrace) => const SizedBox(height: 320),
    );
  }

  Widget _buildCarousel(List<FuelEntry> fuelEntries, List<Trip> trips) {
    final mileageSeries = _buildMileageSeries(fuelEntries);
    final speedSeries = _buildSpeedSeries(trips);

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (index != _pageIndex) {
                  setState(() {
                    _pageIndex = index;
                  });
                }
              },
              children: [
                _MetricCard(
                  key: const ValueKey('mileage-card'),
                  title: 'Mileage',
                  subtitle: 'Efficiency trend',
                  valueLabel: _formatValue(mileageSeries.latestValue, 'KM/L'),
                  points: mileageSeries.points,
                  accent: AppColors.primaryColor,
                  fillGradient: AppColors.primaryGradient,
                  emptyLabel: 'Add fuel fills to unlock mileage trends.',
                  icon: Icons.local_gas_station,
                ),
                _MetricCard(
                  key: const ValueKey('speed-card'),
                  title: 'Speed',
                  subtitle: 'Live trip trend',
                  valueLabel: _formatValue(speedSeries.latestValue, 'KM/H'),
                  points: speedSeries.points,
                  accent: AppColors.accentColor,
                  fillGradient: AppColors.successGradient,
                  emptyLabel: 'Start a trip to unlock live speed trends.',
                  icon: Icons.speed,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildDot(0), const SizedBox(width: 8), _buildDot(1)],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final active = index == _pageIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryColor : AppColors.dividerColor,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  _MetricSeries _buildMileageSeries(List<FuelEntry> fuelEntries) {
    if (fuelEntries.isEmpty) {
      return const _MetricSeries(
        points: [_MetricPoint(label: 'No data', value: 0)],
        average: 0,
        latestValue: 0,
      );
    }

    final points = <_MetricPoint>[];
    FuelEntry? previousEntry;
    for (final entry in fuelEntries) {
      final mileage =
          entry.mileage ??
          (previousEntry != null &&
                  entry.fuelLiters > 0 &&
                  entry.odometer > previousEntry.odometer
              ? (entry.odometer - previousEntry.odometer) / entry.fuelLiters
              : 0);
      points.add(_MetricPoint(label: _shortLabel(entry.date), value: mileage));
      previousEntry = entry;
    }

    final values = points.map((point) => point.value).toList(growable: false);
    final average = values.reduce((a, b) => a + b) / values.length;
    return _MetricSeries(
      points: points,
      average: average,
      latestValue: values.last,
    );
  }

  _MetricSeries _buildSpeedSeries(List<Trip> trips) {
    if (trips.isEmpty) {
      return const _MetricSeries(
        points: [_MetricPoint(label: 'No data', value: 0)],
        average: 0,
        latestValue: 0,
      );
    }

    final points = <_MetricPoint>[];
    for (final trip in trips) {
      points.add(
        _MetricPoint(
          label: _shortLabel(trip.startTime),
          value: trip.avgSpeed ?? 0,
        ),
      );
    }

    final values = points.map((point) => point.value).toList(growable: false);
    final average = values.reduce((a, b) => a + b) / values.length;
    return _MetricSeries(
      points: points,
      average: average,
      latestValue: values.last,
    );
  }

  String _shortLabel(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  String _formatValue(double value, String unit) {
    if (value <= 0) {
      return '0.0 $unit';
    }
    return '${value.toStringAsFixed(1)} $unit';
  }
}

class _MetricCard extends StatelessWidget {

  const _MetricCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.points,
    required this.accent,
    required this.fillGradient,
    required this.emptyLabel,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final String valueLabel;
  final List<_MetricPoint> points;
  final Color accent;
  final Gradient fillGradient;
  final String emptyLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final hasData = points.any((point) => point.value > 0);
    final chartPoints = hasData
        ? [
            for (var i = 0; i < points.length; i++)
              FlSpot(i.toDouble(), points[i].value),
          ]
        : const [FlSpot(0, 0)];
    final maxY = hasData
        ? (chartPoints.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) *
                  1.2)
              .clamp(1.0, double.infinity)
        : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0B1220),
                const Color(0xFF101A2C),
                accent.withValues(alpha: 0.14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: accent.withValues(alpha: 0.16)),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -16,
                top: -12,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                left: -32,
                bottom: -36,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icon, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.68,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            valueLabel,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: hasData
                          ? Column(
                              children: [
                                Expanded(
                                  child: LineChart(
                                    LineChartData(
                                      minY: 0,
                                      maxY: maxY,
                                      gridData: const FlGridData(
                                        show: false,
                                        drawVerticalLine: false,
                                      ),
                                      titlesData: const FlTitlesData(
                                        rightTitles: AxisTitles(
                                          
                                        ),
                                        topTitles: AxisTitles(
                                          
                                        ),
                                        leftTitles: AxisTitles(
                                          
                                        ),
                                        bottomTitles: AxisTitles(
                                          
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineTouchData: const LineTouchData(
                                        enabled: false,
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: chartPoints,
                                          isCurved: true,
                                          color: Colors.white,
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: fillGradient,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    _buildStatPill(
                                      context,
                                      'AVG',
                                      _averageValue(points).toStringAsFixed(1),
                                      accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatPill(
                                      context,
                                      'PEAK',
                                      _peakValue(points).toStringAsFixed(1),
                                      Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatPill(
                                      context,
                                      'POINTS',
                                      points.length.toString(),
                                      Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : _EmptyMetricState(
                              title: emptyLabel,
                              description: title == 'Mileage'
                                  ? 'Add fuel fills to unlock mileage trends.'
                                  : 'Start a trip to unlock live speed trends.',
                              accent: accent,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.62),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _averageValue(List<_MetricPoint> points) {
    if (points.isEmpty) return 0;
    final values = points.map((point) => point.value).toList(growable: false);
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _peakValue(List<_MetricPoint> points) {
    if (points.isEmpty) return 0;
    return points.map((point) => point.value).reduce((a, b) => a > b ? a : b);
  }
}

class _EmptyMetricState extends StatelessWidget {

  const _EmptyMetricState({
    required this.title,
    required this.description,
    required this.accent,
  });
  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactLayout = constraints.maxHeight <= 180;
        final iconSize = compactLayout ? 34.0 : 44.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(compactLayout ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.bgColor.withValues(alpha: 0.55),
            border: Border.all(
              color: AppColors.dividerColor.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      title.contains('Mileage')
                          ? Icons.local_gas_station
                          : Icons.speed,
                      color: accent,
                      size: compactLayout ? 18 : 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'No entries yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: compactLayout ? 2 : 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: compactLayout ? 34 : 42,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.22),
                      accent.withValues(alpha: 0.06),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add data to unlock trends',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricPoint {

  const _MetricPoint({required this.label, required this.value});
  final String label;
  final double value;
}

class _MetricSeries {

  const _MetricSeries({
    required this.points,
    required this.average,
    required this.latestValue,
  });
  final List<_MetricPoint> points;
  final double average;
  final double latestValue;
}
