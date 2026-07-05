# Mileage Calculations Reference

This document provides a detailed breakdown of the formulas, constraints, conditions, and logic used to calculate mileage and fuel efficiency metrics within the Quantane application.

---

## 1. Core Mileage & Cost Formulas

### Individual Fuel Entry Mileage
For every new fuel fill entry, the mileage is computed based on the difference between the current odometer reading and the previous odometer reading.

$$
\text{Mileage (KM/L)} = \frac{\text{Odometer}_{\text{Current}} - \text{Odometer}_{\text{Previous}}}{\text{Fuel Liters}}
$$

*   **File reference:** [fuel_entry.dart](file:///d:/PROG/Android_Dev/quantane/lib/domain/models/fuel_entry.dart) in `FuelEntry.fromDrift`.

### Individual Fuel Entry Cost Per KM
The cost per kilometer measures the monetary expense incurred per kilometer traveled during that fill cycle.

$$
\text{Cost Per KM} = \frac{\text{Fuel Cost}}{\text{Odometer}_{\text{Current}} - \text{Odometer}_{\text{Previous}}}
$$

---

## 2. Calculation Conditions & Constraints

To ensure the integrity of the data and avoid mathematical errors (such as division by zero), several check conditions are implemented in code:

1.  **Odometer Delta Check:**
    Mileage and cost per kilometer are **only** computed if a previous odometer reading exists and the current odometer reading is strictly greater than the previous reading.
    ```dart
    if (previousOdometer != null && data.odometer > previousOdometer) { ... }
    ```
2.  **Zero/Negative Values Check:**
    To calculate mileage, both the distance traveled and the volume of fuel added must be greater than zero.
    ```dart
    if (distance > 0 && data.fuelLiters > 0) { ... }
    ```
    If these conditions are not met, the computed `mileage` and `costPerKm` values default to `null` (stored as optional values).

---

## 3. Aggregations & Metrics Summaries

### Monthly Average Mileage
Monthly average mileage aggregates fuel consumption and distances over a calendar month.

$$
\text{Average Mileage (Monthly)} = \frac{\text{Monthly Fuel Distance}}{\text{Total Liters (Valid Entries)}}
$$

*   **File reference:** [home_providers.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/home/home_providers.dart).
*   **Fuel Distance Calculation:**
    To reconstruct the actual distance traveled for entries in a given period, the system calculates:
    $$
    \text{Fuel Distance} = \sum (\text{Mileage}_i \times \text{Liters}_i)
    $$
    *(Since $\text{Mileage}_i = \text{Distance}_i / \text{Liters}_i$, this effectively reconstructs the distance $\text{Distance}_i$ for each valid fill cycle).*
*   **Total Liters Calculation:**
    The sum of fuel liters is calculated **only** from valid entries that have a non-null computed mileage:
    $$
    \text{Total Liters} = \sum \text{Fuel Liters}_i \quad \text{where } \text{Mileage}_i \neq \text{null}
    $$

### Odometer-Based Lifetime Average Mileage
In the fuel history screen, lifetime averages are calculated using the overall span of odometer readings:

$$
\text{Total Distance} = \text{Odometer}_{\text{Latest}} - \text{Odometer}_{\text{Earliest}}
$$

$$
\text{Average Mileage} = \frac{\text{Total Distance}}{\sum \text{Liters}_i}
$$

*   **File reference:** [fuel_history_screen.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/fuel/fuel_history_screen.dart).

---

## 4. Mileage Trend & Insight Logic

The application compares the current month's mileage against the previous month's mileage to deliver actionable dashboard widgets and warning/success cards.

### Delta Percentage Formula
To show performance changes:

$$
\text{Delta Percent} = \frac{\text{Avg Mileage}_{\text{Current}} - \text{Avg Mileage}_{\text{Previous}}}{\text{Avg Mileage}_{\text{Previous}}} \times 100
$$

*   **Condition:** Calculated only if $\text{Avg Mileage}_{\text{Previous}} > 0$.
*   **File reference:** [home_providers.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/home/home_providers.dart) inside `quickStats`.

### Insight Alerts
The app compares current and last month's averages to generate targeted alerts:
*   **Mileage Improved (Success Banner):**
    *   *Condition:* $\text{Current Mileage} > \text{Last Mileage}$
    *   *Message:* `"Your mileage is up by {delta} KM/L this month!"`
*   **Mileage Dropped (Warning Banner):**
    *   *Condition:* $\text{Current Mileage} < \text{Last Mileage}$
    *   *Message:* `"Your mileage decreased. Check your tire pressure."`

*   **File reference:** [insight_engine.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/shared/utils/insight_engine.dart).
