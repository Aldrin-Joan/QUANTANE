// Dart imports:
import 'dart:async';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/analytics_summary.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

part 'home_providers.g.dart';

class HomeMetricsSnapshot {

  const HomeMetricsSnapshot({required this.fuelEntries, required this.trips});
  final List<FuelEntry> fuelEntries;
  final List<Trip> trips;
}

@riverpod
Stream<HomeMetricsSnapshot?> homeMetrics(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value(null);

  final fuelRepo = ref.watch(fuelRepositoryProvider);
  final tripRepo = ref.watch(tripRepositoryProvider);

  final controller = StreamController<HomeMetricsSnapshot>();
  var fuelEntries = const <FuelEntry>[];
  var trips = const <Trip>[];

  void emitSnapshot() {
    if (!controller.isClosed) {
      controller.add(
        HomeMetricsSnapshot(fuelEntries: fuelEntries, trips: trips),
      );
    }
  }

  final fuelSubscription = fuelRepo.watchAll(vehicleId).listen((entries) {
    fuelEntries = entries;
    emitSnapshot();
  }, onError: controller.addError);

  final tripSubscription = tripRepo.watchAll(vehicleId).listen((values) {
    trips = values;
    emitSnapshot();
  }, onError: controller.addError);

  emitSnapshot();

  ref.onDispose(() {
    unawaited(fuelSubscription.cancel());
    unawaited(tripSubscription.cancel());
    controller.close();
  });

  return controller.stream;
}

@riverpod
HomeSummary? homeSummary(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return null;

  final metrics = ref.watch(homeMetricsProvider);
  return metrics.maybeWhen(
    data: (snapshot) {
      if (snapshot == null) return null;

      final now = DateTime.now();
      final fuelEntries = snapshot.fuelEntries;
      final trips = snapshot.trips;
      final currentFuelEntries = _entriesForMonthOrAll(fuelEntries, now);
      final validFuelEntries = _validEntries(currentFuelEntries);
      final tripDistance = _totalDistanceFromTrips(trips);
      final fuelDistance = _totalDistanceFromFuelEntries(validFuelEntries);
      final totalDistance = tripDistance > 0 ? tripDistance : fuelDistance;
      final totalLiters = _totalLitersFromFuelEntries(validFuelEntries);
      final avgMileage = totalLiters > 0 ? fuelDistance / totalLiters : 0.0;
      final spend = _monthlySpendFromFuelEntries(currentFuelEntries, now);

      return HomeSummary(
        totalSpendMonth: spend,
        totalDistanceMonth: totalDistance,
        avgMileageMonth: avgMileage,
      );
    },
    orElse: () => null,
  );
}

@riverpod
QuickStats? quickStats(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return null;

  final metrics = ref.watch(homeMetricsProvider);
  return metrics.maybeWhen(
    data: (snapshot) {
      if (snapshot == null) return null;

      final now = DateTime.now();
      final fuelEntries = snapshot.fuelEntries;
      final trips = snapshot.trips;
      final currentFuelEntries = _entriesForMonthOrAll(fuelEntries, now);
      final previousFuelEntries = _entriesForMonth(
        fuelEntries,
        DateTime(now.year, now.month - 1),
      );
      final validFuelEntries = _validEntries(currentFuelEntries);
      final fuelDistance = _totalDistanceFromFuelEntries(validFuelEntries);
      final totalLiters = _totalLitersFromFuelEntries(validFuelEntries);
      final avgMileage = totalLiters > 0 ? fuelDistance / totalLiters : 0.0;
      final totalSpend = _totalSpendFromFuelEntries(currentFuelEntries);
      final costPerKm = fuelDistance > 0 ? totalSpend / fuelDistance : 0.0;
      final avgSpeed = _averageTripSpeed(trips);
      final previousMileage = _averageMileageFromFuelEntries(
        _validEntries(previousFuelEntries),
      );
      final avgMileageDeltaPercent = previousMileage > 0
          ? ((avgMileage - previousMileage) / previousMileage) * 100
          : null;

      return QuickStats(
        avgMileage: avgMileage,
        avgMileageDeltaPercent: avgMileageDeltaPercent,
        totalDistance: fuelDistance,
        avgSpeed: avgSpeed,
        costPerKm: costPerKm,
      );
    },
    orElse: () => null,
  );
}

double _totalDistanceFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(
    0,
    (sum, entry) => sum + ((entry.mileage ?? 0.0) * entry.fuelLiters),
  );
}

List<FuelEntry> _validEntries(List<FuelEntry> entries) {
  return entries.where((entry) => entry.mileage != null).toList();
}

List<FuelEntry> _entriesForMonth(List<FuelEntry> entries, DateTime month) {
  return entries
      .where(
        (entry) =>
            entry.date.year == month.year && entry.date.month == month.month,
      )
      .toList();
}

List<FuelEntry> _entriesForMonthOrAll(List<FuelEntry> entries, DateTime month) {
  final monthEntries = _entriesForMonth(entries, month);
  return monthEntries.isNotEmpty ? monthEntries : entries;
}

double _averageMileageFromFuelEntries(List<FuelEntry> entries) {
  final totalDistance = _totalDistanceFromFuelEntries(entries);
  final totalLiters = _totalLitersFromFuelEntries(entries);
  return totalLiters > 0 ? totalDistance / totalLiters : 0.0;
}

double _totalDistanceFromTrips(List<Trip> trips) {
  return trips.fold<double>(0, (sum, trip) => sum + trip.distance);
}

double _averageTripSpeed(List<Trip> trips) {
  final validTrips = trips.where((trip) => trip.endTime != null).toList();
  if (validTrips.isEmpty) {
    return 0;
  }

  final totalDistance = validTrips.fold<double>(
    0,
    (sum, trip) => sum + trip.distance,
  );
  final totalHours = validTrips.fold<double>(0, (sum, trip) {
    final duration =
        trip.endTime!.difference(trip.startTime).inSeconds / 3600.0;
    return sum + (duration > 0 ? duration : 0.0);
  });

  if (totalHours <= 0) {
    return 0;
  }

  return totalDistance / totalHours;
}

double _totalLitersFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0, (sum, entry) => sum + entry.fuelLiters);
}

double _totalSpendFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0, (sum, entry) => sum + entry.fuelCost);
}

double _monthlySpendFromFuelEntries(List<FuelEntry> entries, DateTime now) {
  return entries.fold<double>(0, (sum, entry) {
    final sameMonth =
        entry.date.year == now.year && entry.date.month == now.month;
    return sameMonth ? sum + entry.fuelCost : sum;
  });
}
