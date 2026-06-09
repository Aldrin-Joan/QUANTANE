# Quantane Formula Reference

This document records the formulas currently used in the app codebase. It is intended as a code-aligned reference, not a product spec.

## Fuel

### Per-entry fuel economy

Used by `FuelEntry.fromDrift` in [lib/domain/models/fuel_entry.dart](../lib/domain/models/fuel_entry.dart).

$$
	ext{Mileage (KM/L)} = \frac{\text{Odometer}_{\text{Current}} - \text{Odometer}_{\text{Previous}}}{\text{Fuel Liters}}
$$

Current implementation details:

- `mileage` is computed only when a previous odometer reading exists and the current odometer is greater than the previous reading.
- `costPerKm` is computed as:

$$
	ext{Cost Per KM} = \frac{\text{Fuel Cost}}{\text{Distance Traveled}}
$$

### Fuel history overview

Used by [lib/features/fuel/fuel_history_screen.dart](../lib/features/fuel/fuel_history_screen.dart).

The summary card uses the oldest and latest odometer readings in the displayed fuel history:

$$
	ext{Total Distance} = \text{Latest Odometer} - \text{First Odometer}
$$

$$
\text{Total Liters} = \sum \text{Liters}_i
$$

$$
\text{Average Mileage} = \frac{\text{Total Distance}}{\text{Total Liters}}
$$

$$
\text{Total Spend} = \sum \text{Fuel Cost}_i
$$

### Fuel entry delta badge

Used by `DeltaBadge` in [lib/features/shared/widgets/delta_badge.dart](../lib/features/shared/widgets/delta_badge.dart).

For fuel entries, the badge is fed a percentage change value:

$$
\text{Delta Percent} = \frac{\text{Current Mileage} - \text{Previous Mileage}}{\text{Previous Mileage}} \times 100
$$

## Trips

### Trip distance and speed tracking

Used by [lib/features/trips/trip_tracking_service.dart](../lib/features/trips/trip_tracking_service.dart).

Current speed is derived in this order:

$$
\text{Speed}_{km/h} = \text{Platform Speed}_{m/s} \times 3.6
$$

If platform speed is not available, the service derives speed from position deltas:

$$
\text{Speed}_{km/h} = \frac{\text{Distance Between Positions}_{m}}{\text{Elapsed Seconds}} \times 3.6
$$

Trip distance is accumulated from consecutive GPS points:

$$
\text{Trip Distance}_{km} = \sum \left(\frac{\text{Step Distance}_{m}}{1000}\right)
$$

Only reasonble step distances are counted; very large jumps are ignored by the tracking service.

### Live trip average speed

Used by [lib/features/trips/live_trip_screen.dart](../lib/features/trips/live_trip_screen.dart).

$$
\text{Average Speed} = \frac{\text{Distance}_{km}}{\text{Duration}_{hours}}
$$

Where duration is calculated from the trip start time to the stop time.

### Trip history cards

Used by [lib/features/trips/trips_screen.dart](../lib/features/trips/trips_screen.dart).

- Distance shown is the stored trip distance.
- Average speed shown is the stored trip average speed.
- Max speed shown is the stored trip max speed.
- Duration shown is:

$$
\text{Duration} = \text{End Time} - \text{Start Time}
$$

## Home Summary

Used by [lib/features/home/home_providers.dart](../lib/features/home/home_providers.dart).

### Monthly spend

$$
\text{Monthly Spend} = \sum \text{Fuel Cost for entries in the current month}
$$

### Monthly total distance

The app prefers trip distance if trips exist for the active vehicle; otherwise it falls back to fuel-derived distance.

Trip distance:

$$
\text{Trip Distance} = \sum \text{Trip Distance}_i
$$

Fuel-derived distance:

$$
\text{Fuel Distance} = \sum (\text{Mileage}_i \times \text{Liters}_i)
$$

Selected monthly total distance:

$$
\text{Total Distance} =
\begin{cases}
\text{Trip Distance}, & \text{if trip distance} > 0 \\
\text{Fuel Distance}, & \text{otherwise}
\end{cases}
$$

### Monthly average mileage

$$
\text{Average Mileage} = \frac{\text{Fuel Distance}}{\text{Total Liters}}
$$

In code, `Fuel Distance`, `Total Liters`, and `Monthly Spend` are all calculated from fuel entries in the current calendar month.

## Quick Stats

Used by [lib/features/home/widgets/quick_stats_grid.dart](../lib/features/home/widgets/quick_stats_grid.dart).

### Average mileage

$$
\text{Avg Mileage} = \frac{\text{Fuel Distance}}{\text{Total Liters}}
$$

### Cost per km

$$
\text{Cost per KM} = \frac{\text{Total Spend}}{\text{Total Distance}}
$$

### Average trip speed

$$
\text{Avg Trip Speed} = \frac{\text{Total Trip Distance}}{\text{Total Trip Hours}}
$$

Where only completed trips are used in the calculation.

## Insights

Used by [lib/features/home/insight_providers.dart](../lib/features/home/insight_providers.dart).

### Current mileage

$$
	ext{Current Mileage} = \text{Average Mileage of the current calendar month}
$$

### Previous mileage used for insight generation

$$
	ext{Previous Mileage} = \text{Average Mileage of the previous calendar month}
$$

This is used to generate a comparison signal for the insight engine.

## Notes

- The app computes several summaries from persisted data rather than hardcoded values.
- Mileage and spend calculations depend on the currently selected vehicle.
- Trip and fuel summaries use different sources where appropriate, but the shared summary math is always derived from the underlying data.