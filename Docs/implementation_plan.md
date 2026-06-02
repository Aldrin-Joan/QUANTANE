# Quantane — Implementation Plan

> Flutter-native, offline-first fuel & vehicle analytics platform.
> Stack: Flutter · Dart · SQLite (drift) · Riverpod · fl_chart · go_router · geolocator

---

## Phase 0 — Project Bootstrap (Day 1–2)

**Goal:** Runnable shell with routing, theming, and DB skeleton.

### 0.1 Flutter project init
```bash
flutter create quantane --org com.quantane --platforms android,ios
cd quantane
```

### 0.2 Add core dependencies (`pubspec.yaml`)
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  drift: ^2.19.0
  drift_flutter: ^0.2.0
  sqlite3_flutter_libs: ^0.5.24
  geolocator: ^12.0.0
  fl_chart: ^0.68.0
  lucide_icons: ^0.0.4
  intl: ^0.19.0
  uuid: ^4.4.2
  shared_preferences: ^2.3.1
  path_provider: ^2.1.4

dev_dependencies:
  drift_dev: ^2.19.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
```

### 0.3 Folder structure
```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   ├── router/
│   │   └── app_router.dart
│   └── utils/
│       ├── formatters.dart
│       └── extensions.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart       # drift DB definition
│   │   ├── app_database.g.dart
│   │   └── tables/
│   │       ├── vehicles_table.dart
│   │       ├── fuel_entries_table.dart
│   │       └── trips_table.dart
│   └── repositories/
│       ├── vehicle_repository.dart
│       ├── fuel_repository.dart
│       └── trip_repository.dart
├── domain/
│   └── models/
│       ├── vehicle.dart
│       ├── fuel_entry.dart
│       ├── trip.dart
│       └── analytics_summary.dart
├── features/
│   ├── home/
│   ├── fuel/
│   ├── trips/
│   ├── analytics/
│   ├── vehicles/
│   └── settings/
└── main.dart
```

---

## Phase 1 — Data Layer (Day 3–5)

**Goal:** Full offline persistence via drift + repository pattern.

### 1.1 Drift table definitions

```dart
// vehicles_table.dart
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();          // bike | car | truck
  TextColumn get fuelType => text()();      // petrol | diesel | ev | cng
  RealColumn get tankCapacity => real().nullable()();
  TextColumn get createdAt => text()();
  @override
  Set<Column> get primaryKey => {id};
}

// fuel_entries_table.dart
class FuelEntries extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  TextColumn get date => text()();
  RealColumn get fuelCost => real()();
  RealColumn get fuelLiters => real()();
  RealColumn get odometer => real()();
  TextColumn get station => text().nullable()();
  TextColumn get notes => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// trips_table.dart
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text().nullable()();
  RealColumn get distance => real().withDefault(const Constant(0.0))();
  RealColumn get avgSpeed => real().nullable()();
  RealColumn get maxSpeed => real().nullable()();
  RealColumn get minSpeed => real().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}
```

### 1.2 Computed fields (in repositories, not DB)
- **Mileage (KM/L):** `(currentOdo - prevOdo) / liters`
- **Cost/KM:** `fuelCost / (currentOdo - prevOdo)`
- **Monthly spend:** SQL `WHERE date BETWEEN ? AND ?` aggregation

### 1.3 Repository interfaces
Each repository exposes:
- `Stream<List<T>> watchAll(String vehicleId)` — reactive UI binding
- `Future<T?> getById(String id)`
- `Future<void> insert(T entity)`
- `Future<void> update(T entity)`
- `Future<void> delete(String id)`

---

## Phase 2 — Core UI Shell (Day 6–8)

**Goal:** Navigation, theming, scaffold working end-to-end.

### 2.1 Theme (`app_theme.dart`)
```dart
const kBgColor        = Color(0xFF0B0F14);
const kCardColor      = Color(0xFF121821);
const kPrimaryColor   = Color(0xFF3B82F6);
const kAccentColor    = Color(0xFF22C55E);
const kWarningColor   = Color(0xFFF59E0B);
const kDangerColor    = Color(0xFFEF4444);
const kTextPrimary    = Color(0xFFF1F5F9);
const kTextSecondary  = Color(0xFF94A3B8);
```

ThemeData: `brightness: Brightness.dark`, `scaffoldBackgroundColor: kBgColor`, `useMaterial3: true`

### 2.2 Bottom navigation (go_router StatefulShellRoute)
Tabs: Home · Trips · Fuel · Analytics · Settings

### 2.3 Shared widgets to build first
- `QuantaneCard` — glassmorphism card with 24px radius
- `StatTile` — icon + label + value compact tile
- `SectionHeader` — section label with optional action button
- `EmptyState` — illustration + message for empty lists
- `LoadingShimmer` — skeleton loader for async data

---

## Phase 3 — Home Dashboard (Day 9–11)

**Goal:** Hero summary + quick stats + weekly chart.

### 3.1 Hero card
- Fuel spent this month (₹)
- Total KM this month
- Average mileage (KM/L)
- Derived from `FuelRepository.getMonthlySummary(vehicleId, month)`

### 3.2 Quick stats grid (2×2)
- Avg Mileage · Total Distance · Avg Speed · Cost/KM
- Riverpod `FutureProvider` for each derived metric

### 3.3 Weekly spending chart
- `fl_chart` LineChart
- X-axis: last 7 days labels
- Y-axis: ₹ spent
- Data: `FuelRepository.getDailySpend(vehicleId, last7days)`

### 3.4 Recent activity feed
- Interleaved fuel fills and trip completions
- `Stream<List<ActivityItem>>` merged from both repositories

---

## Phase 4 — Fuel Management (Day 12–14)

### 4.1 Fuel history screen
- `ListView.builder` of `FuelEntryCard`
- Each card: date, cost, liters, odometer, computed mileage vs prev fill
- Color-coded mileage delta (green = improved, red = dropped)

### 4.2 Add fuel bottom sheet
Fields (all validated):
- Cost (₹) — numeric keyboard
- Liters — decimal
- Odometer (KM) — numeric, must be ≥ last reading
- Station — optional, dropdown: Shell / Indian Oil / BP / BPCL / HP / Other
- Notes — optional text

On save:
1. Auto-calculate mileage from prev odometer entry
2. Insert via `FuelRepository.insert()`
3. Trigger smart insight check

### 4.3 Fuel entry detail + edit/delete

---

## Phase 5 — Trip Tracking (Day 15–18)

**Goal:** Live GPS trip with real-time speed gauge.

### 5.1 Permissions
```dart
// AndroidManifest.xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

### 5.2 Trip tracking service
```dart
class TripTrackingService {
  final _positions = <Position>[];
  StreamSubscription<Position>? _sub;

  void start() {
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,           // meters
      ),
    ).listen(_onPosition);
  }

  void _onPosition(Position p) {
    _positions.add(p);
    // update currentSpeed, distance, maxSpeed, minSpeed
  }

  TripResult stop() {
    _sub?.cancel();
    return _computeSummary();
  }
}
```

### 5.3 Live trip screen
- Large circular speed gauge (custom `CustomPainter` or `fl_chart` RadarChart)
- Current speed (center, large text)
- Top speed · Distance · Duration (live counter)
- Stop button → confirmation dialog → save trip

### 5.4 Trip history list
- Card: date, distance, duration, avg/max speed
- Tap → trip detail screen

---

## Phase 6 — Analytics (Day 19–22)

**Goal:** The portfolio showcase screen.

### 6.1 Fuel spending chart
- Tab switcher: Week / Month / Year
- `fl_chart` BarChart or LineChart
- Animated on tab switch

### 6.2 Mileage analysis
- Best / Worst / Average KM/L
- Trend line over last N fills

### 6.3 Speed analysis
- Bar chart: avg speed per trip (last 10 trips)
- Overlay: max speed markers

### 6.4 Cost analysis
- Total fuel cost (period)
- Cost/KM trend line
- Monthly average bar

### 6.5 Data queries
All analytics computed in `AnalyticsRepository` via drift SQL:
```dart
Future<AnalyticsSummary> getSummary(String vehicleId, DateRange range);
Stream<List<DailySpend>> watchDailySpend(String vehicleId, int days);
Future<MileageStats> getMileageStats(String vehicleId);
```

---

## Phase 7 — Vehicle Management (Day 23–24)

- Vehicle list screen with card per vehicle
- Add/edit vehicle bottom sheet: name, type, fuel type, tank capacity, purchase date, initial odometer
- Delete vehicle (with confirmation; cascades to fuel entries and trips)
- Active vehicle selector (persisted via `SharedPreferences`)

---

## Phase 8 — Smart Insights Engine (Day 25–26)

Generate insight strings shown on Home screen and as in-app banners.

```dart
class InsightEngine {
  List<String> generate(AnalyticsSummary current, AnalyticsSummary prev) {
    final insights = <String>[];
    final mileDelta = current.avgMileage - prev.avgMileage;
    if (mileDelta > 0) {
      insights.add('Mileage improved ${mileDelta.toStringAsFixed(1)} KM/L this month 🟢');
    }
    final spendDelta = current.totalCost - prev.totalCost;
    if (spendDelta < 0) {
      insights.add('Fuel spend down ₹${spendDelta.abs().toInt()} vs last month');
    }
    return insights;
  }
}
```

---

## Phase 9 — Settings & Polish (Day 27–28)

### 9.1 Settings screen
- Active vehicle selector
- Currency symbol (₹ default, configurable)
- Distance unit (KM / Miles)
- Export data (JSON)
- Clear all data

### 9.2 Performance targets
- App startup: < 1 second (lazy-load heavy screens)
- Dashboard render: < 300ms (cached Riverpod providers)
- GPS update interval: 2 seconds
- Use `const` constructors everywhere possible
- Drift queries on background isolate

---

## Phase 10 — QA & Release Build (Day 29–30)

- Widget tests for all custom widgets
- Integration test: add fuel → verify mileage calculation
- Integration test: start trip → stop → verify save
- `flutter build apk --release --split-per-abi`
- `flutter build ipa`
- Play Store / App Store metadata and screenshots

---

## Milestone Summary

| Phase | Deliverable | Days |
|---|---|---|
| 0 | Project bootstrap | 1–2 |
| 1 | Data layer (drift + repos) | 3–5 |
| 2 | UI shell + theming | 6–8 |
| 3 | Home dashboard | 9–11 |
| 4 | Fuel management | 12–14 |
| 5 | GPS trip tracking | 15–18 |
| 6 | Analytics screens | 19–22 |
| 7 | Vehicle management | 23–24 |
| 8 | Smart insights | 25–26 |
| 9 | Settings + polish | 27–28 |
| 10 | QA + release | 29–30 |
