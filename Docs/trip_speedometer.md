# Trip Speedometer Documentation

This document describes the technologies, libraries, mathematical rules, and UI warning conditions implemented for the trip speedometer and live tracking system in the Quantane application.

---

## 1. Core Technologies & Libraries

The live trip tracking and speedometer subsystem relies on the following packages:

*   **`geolocator` (^14.0.2):** Used to request location permissions, obtain raw GPS coordinates, poll speed from the hardware GPS sensor, and calculate high-precision geodesic distances between sequential coordinates.
*   **`flutter_foreground_task` (^9.2.2):** Enables running a persistent background service with an active system notification, preventing the Android OS from suspending GPS tracking when the app is minimized or the screen is locked.
*   **`wakelock_plus` (^1.2.8):** Keeps the device screen turned on during live trip tracking sessions to provide continuous speedometer visibility.
*   **`flutter_map` (^7.0.2) & `latlong2` (^0.9.1):** Renders the user's current position and trailing route polyline in real-time.

---

## 2. GPS Location & Speed Processing Rules

To maintain high data accuracy and prevent jumps caused by GPS noise or signal reflections, the `TripMetricsCalculator` processes all location updates through a series of filters.

### A. Data Quality Filters
1.  **Horizontal Accuracy Filter:**
    If the horizontal accuracy radius is greater than **30.0 meters**, the coordinate is discarded immediately.
    ```dart
    if (position.accuracy > maxAccuracyMeters) { return current; } // maxAccuracyMeters = 30.0
    ```
2.  **Temporal Filter:**
    If the timestamp of the incoming position is prior to the timestamp of the last recorded position, it is rejected (prevents out-of-order execution).
3.  **Realistic Speed Filter:**
    If the derived speed exceeds **250.0 km/h**, it is treated as GPS noise or a telemetry glitch, and the coordinate is discarded.

### B. Derived Speed Calculation
The distance and speed are calculated from consecutive GPS coordinates:
*   **Distance calculation:** Calculated using the geodesic distance formula via `Geolocator.distanceBetween()`.
*   **Step threshold:** A step is only considered valid if the distance is at least **3.0 meters** (`minUsefulStepMeters`).
*   **Formula:**
    $$
    \text{Derived Speed (km/h)} = \left(\frac{\text{Distance (meters)}}{\text{Elapsed Time (seconds)}}\right) \times 3.6
    $$

### C. Speed Estimation Logic
The speedometer estimates current speed using a hybrid approach combining raw GPS sensor readings and calculated coordinate deltas:
1.  **Mock Location Check:** If the location is flagged as simulated (`position.isMocked == true`), speed is forced to `0.0 km/h` to prevent spoofing.
2.  **Zero-Motion Filter:** To prevent speedometer jitter when the vehicle is stationary, speed is forced to `0.0 km/h` if the coordinate-derived speed is less than **3.0 km/h**.
3.  **Sensor vs. Derived Evaluation:**
    *   If the reported GPS sensor speed is less than the sensor's speed accuracy margin, the system trusts the coordinate-derived speed:
        ```dart
        if (reportedSpeed < speedAccuracy) { return derivedSpeed; }
        ```
    *   Otherwise, the system displays the higher of the two values:
        ```dart
        return max(reportedSpeed, derivedSpeed);
        ```

*   **File reference:** [trip_session_models.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/trips/trip_session_models.dart) in `TripMetricsCalculator._estimateCurrentSpeed`.

---

## 3. Speedometer UI & Warning System

The speedometer display changes dynamically based on current speed thresholds and configured safety limits.

### A. Display Modes
*   **Digital Gauge:** Renders a large numeric speed readout inside a custom painted gradient circular arc.
*   **Analog Gauge:** Displays a classical dial dial-face with a sweeping needle showing the speed relative to the maximum gauge limit (default: `200 km/h`).
*   **File reference:** [speed_gauge.dart](file:///d:/PROG/Android_Dev/quantane/lib/features/trips/widgets/speed_gauge.dart).

### B. Speed-Color Coding Rules
The gauge outline and needle color change contextually based on safety thresholds:
*   **Normal / Accent (Green/Teal):** $\text{Speed} \le 50 \text{ km/h}$
*   **Warning (Orange/Yellow):** $50 \text{ km/h} < \text{Speed} \le 80 \text{ km/h}$
*   **Alert / Danger (Red):** $\text{Speed} > 80 \text{ km/h}$

### C. Speed Warning Banners
When specific limits are exceeded, warning banners are overlaid on the speedometer:
*   **No Warning:** $\text{Speed} \le 80 \text{ km/h}$
*   **Warning Banner:** $80 \text{ km/h} < \text{Speed} \le 100 \text{ km/h}$
    *   *Message:* `"Slow down. You are exceeding the speed limit."`
*   **Critical Danger Banner:** $\text{Speed} > 100 \text{ km/h}$
    *   *Message:* `"Exceeding speed limit. Reduce speed immediately."`
