# Quantane — Task Tracker

> Granular engineering tasks. Each task is self-contained and assignable.
> Status: `[ ]` todo · `[~]` in progress · `[x]` done

---

## PHASE 0 — Bootstrap

- [ ] **T-001** Run `flutter create quantane --org com.quantane --platforms android,ios`
- [ ] **T-002** Add all dependencies to `pubspec.yaml` and run `flutter pub get`
- [ ] **T-003** Create full folder structure under `lib/` as specified in implementation plan
- [ ] **T-004** Set up `main.dart` with `ProviderScope` wrapping `QuantaneApp`
- [ ] **T-005** Configure Android permissions in `AndroidManifest.xml` (location, foreground service)
- [ ] **T-006** Configure iOS permissions in `Info.plist` (NSLocationWhenInUseUsageDescription)
- [ ] **T-007** Run initial build on Android emulator — confirm clean compile

---

## PHASE 1 — Data Layer

### Drift Tables
- [ ] **T-008** Write `VehiclesTable` drift table class
- [ ] **T-009** Write `FuelEntriesTable` drift table class
- [ ] **T-010** Write `TripsTable` drift table class
- [ ] **T-011** Write `AppDatabase` class wiring all 3 tables
- [ ] **T-012** Run `dart run build_runner build` — confirm `.g.dart` generated
- [ ] **T-013** Write drift DAOs: `VehiclesDao`, `FuelEntriesDao`, `TripsDao`

### Domain Models
- [ ] **T-014** Write `Vehicle` domain model (Dart class, fromDrift constructor)
- [ ] **T-015** Write `FuelEntry` domain model with computed fields (`mileage`, `costPerKm`)
- [ ] **T-016** Write `Trip` domain model
- [ ] **T-017** Write `AnalyticsSummary` aggregate model
- [ ] **T-018** Write `DailySpend` model (date + amount)
- [ ] **T-019** Write `ActivityItem` sealed class (union of FuelEntry | Trip)

### Repositories
- [ ] **T-020** Write `VehicleRepository` — CRUD + `watchAll` stream
- [ ] **T-021** Write `FuelRepository` — CRUD + `getMonthlySummary` + `getDailySpend` + `getMileageStats`
- [ ] **T-022** Write `TripRepository` — CRUD + `watchRecent`
- [ ] **T-023** Write `AnalyticsRepository` — `getSummary(vehicleId, DateRange)`
- [ ] **T-024** Unit test: mileage calculation (prev odo 25000, current 25400, 10L → 40 KM/L)
- [ ] **T-025** Unit test: costPerKm calculation

### Riverpod Providers
- [ ] **T-026** Write `appDatabaseProvider` (singleton, drift)
- [ ] **T-027** Write `vehicleRepositoryProvider`
- [ ] **T-028** Write `fuelRepositoryProvider`
- [ ] **T-029** Write `tripRepositoryProvider`
- [ ] **T-030** Write `activeVehicleProvider` (reads from SharedPreferences)

---

## PHASE 2 — UI Shell

### Theme
- [ ] **T-031** Write `colors.dart` — define all color constants
- [ ] **T-032** Write `app_theme.dart` — build full `ThemeData` (dark, Material3)
- [ ] **T-033** Define `TextTheme` — display, headline, body, label sizes
- [ ] **T-034** Define `CardTheme`, `BottomNavigationBarTheme`, `InputDecorationTheme`

### Router
- [ ] **T-035** Write `app_router.dart` using `go_router` `StatefulShellRoute`
- [ ] **T-036** Define 5 shell branches: home, trips, fuel, analytics, settings
- [ ] **T-037** Define nested routes: `/fuel/add`, `/trips/:id`, `/vehicles/add`, `/vehicles/:id/edit`

### Shared Widgets
- [ ] **T-038** Build `QuantaneCard` widget (glassmorphism, 24px radius, optional gradient border)
- [ ] **T-039** Build `StatTile` widget (icon + label + value + optional delta badge)
- [ ] **T-040** Build `SectionHeader` widget (title + optional trailing action)
- [ ] **T-041** Build `EmptyState` widget (SVG illustration slot + title + subtitle + optional CTA)
- [ ] **T-042** Build `LoadingShimmer` widget (animated skeleton, configurable width/height)
- [ ] **T-043** Build `DeltaBadge` widget (green ↑ / red ↓ percentage pill)
- [ ] **T-044** Build `QuantaneBottomNav` stateful widget

---

## PHASE 3 — Home Dashboard

- [ ] **T-045** Build `HomeScreen` scaffold
- [ ] **T-046** Build `HeroSummaryCard` — month spend + KM + avg mileage in single card
- [ ] **T-047** Write `homeSummaryProvider` Riverpod provider (FutureProvider)
- [ ] **T-048** Build `QuickStatsGrid` — 2×2 grid of `StatTile`s
- [ ] **T-049** Write `quickStatsProvider` (avg mileage, total dist, avg speed, cost/KM)
- [ ] **T-050** Build `WeeklySpendChart` using `fl_chart` LineChart
- [ ] **T-051** Write `weeklySpendProvider` returning `List<DailySpend>` for last 7 days
- [ ] **T-052** Build `RecentActivityFeed` — merged list of recent fuel + trip items
- [ ] **T-053** Write `recentActivityProvider` (limit 5, sorted by date desc)
- [ ] **T-054** Build `ActivityCard` widget (fuel variant + trip variant)
- [ ] **T-055** Write `SmartInsightBanner` — horizontal scroll of insight chips
- [ ] **T-056** Wire full `HomeScreen` with all sub-widgets + providers

---

## PHASE 4 — Fuel Management

- [ ] **T-057** Build `FuelHistoryScreen` with `ListView.builder`
- [ ] **T-058** Build `FuelEntryCard` — date, cost, liters, odo, mileage, delta badge
- [ ] **T-059** Write `fuelHistoryProvider` (stream, filtered by active vehicle)
- [ ] **T-060** Build `AddFuelSheet` bottom sheet
- [ ] **T-061** Add form fields: cost, liters, odometer (with validation)
- [ ] **T-062** Add station dropdown (Shell, Indian Oil, BP, BPCL, HP, Other)
- [ ] **T-063** Add notes optional text field
- [ ] **T-064** Implement save logic: validate → compute mileage → insert → dismiss sheet
- [ ] **T-065** Show error if odometer < previous reading
- [ ] **T-066** Build `FuelEntryDetailScreen` (read-only summary)
- [ ] **T-067** Add edit support: pre-populate `AddFuelSheet` with existing entry
- [ ] **T-068** Add delete with confirmation dialog
- [ ] **T-069** FAB on `FuelHistoryScreen` opens `AddFuelSheet`

---

## PHASE 5 — Trip Tracking

- [ ] **T-070** Build `TripsScreen` — history list + start trip FAB
- [ ] **T-071** Build `TripCard` — date, distance, duration, speeds
- [ ] **T-072** Write `tripHistoryProvider` (stream, active vehicle)
- [ ] **T-073** Write `TripTrackingService` (start/stop, position stream, accumulates data)
- [ ] **T-074** Write `tripTrackingProvider` (StateNotifier managing live trip state)
- [ ] **T-075** Build `LiveTripScreen` — navigate to on start
- [ ] **T-076** Build `SpeedGauge` custom painter widget (circular, 0–200 KM/H arc)
- [ ] **T-077** Display current speed in gauge center (large, animates)
- [ ] **T-078** Display top speed, distance, elapsed duration (live updating)
- [ ] **T-079** Build stop trip button with confirmation dialog
- [ ] **T-080** On stop: compute summary → insert Trip → navigate to trip detail
- [ ] **T-081** Build `TripDetailScreen` — full stats breakdown
- [ ] **T-082** Handle location permission denied — show graceful error + settings deeplink
- [ ] **T-083** Prevent screen sleep during active trip (`wakelock_plus` package)

---

## PHASE 6 — Analytics

- [ ] **T-084** Build `AnalyticsScreen` scaffold with custom tab bar (Week/Month/Year)
- [ ] **T-085** Write `analyticsSummaryProvider(DateRange)` family provider
- [ ] **T-086** Build `SpendingChart` section — BarChart (weekly) / LineChart (monthly, yearly)
- [ ] **T-087** Animate chart on tab switch (`AnimatedSwitcher`)
- [ ] **T-088** Build `MileageAnalysisSection` — best/worst/avg + trend line
- [ ] **T-089** Write `mileageStatsProvider` (derived from fuel entries)
- [ ] **T-090** Build `SpeedAnalysisSection` — bar chart of avg speed per recent trip
- [ ] **T-091** Build `CostAnalysisSection` — total cost, cost/KM trend, monthly avg bar
- [ ] **T-092** Add "No data" empty state for each chart section independently
- [ ] **T-093** Add chart tap interactions — show tooltip with exact value

---

## PHASE 7 — Vehicle Management

- [ ] **T-094** Build `VehiclesScreen` — list of vehicle cards + add FAB
- [ ] **T-095** Build `VehicleCard` — name, type icon, fuel type, odometer
- [ ] **T-096** Write `vehicleListProvider` (stream)
- [ ] **T-097** Build `AddVehicleSheet` — name, type (bike/car/truck), fuel type, tank capacity, purchase date, initial odometer
- [ ] **T-098** Implement save vehicle logic
- [ ] **T-099** Build edit vehicle flow (pre-populate sheet)
- [ ] **T-100** Implement delete vehicle (confirmation + cascade confirm warning)
- [ ] **T-101** Build active vehicle selector in `VehiclesScreen` (radio or highlight)
- [ ] **T-102** Persist active vehicle ID to `SharedPreferences` on select

---

## PHASE 8 — Smart Insights

- [ ] **T-103** Write `InsightEngine` class with pure functions
- [ ] **T-104** Implement mileage improvement/drop insight
- [ ] **T-105** Implement spend increase/decrease vs last period insight
- [ ] **T-106** Implement "best fill" insight (highest single-fill mileage this month)
- [ ] **T-107** Implement "no fills logged" nudge (if no entry in > 7 days)
- [ ] **T-108** Write `insightsProvider` (computes on analytics summary)
- [ ] **T-109** Wire insights into `HomeScreen` banner
- [ ] **T-110** Wire insights into `AnalyticsScreen` header

---

## PHASE 9 — Settings

- [ ] **T-111** Build `SettingsScreen` scaffold
- [ ] **T-112** Add active vehicle selector row (links to `VehiclesScreen`)
- [ ] **T-113** Add currency symbol setting (₹ / $ / € / £ — stored in SharedPreferences)
- [ ] **T-114** Add distance unit setting (KM / Miles)
- [ ] **T-115** Implement export data — serialize all DB tables to JSON, share via system share sheet
- [ ] **T-116** Add "Clear all data" with double-confirmation dialog
- [ ] **T-117** Add app version row (reads from `package_info_plus`)

---

## PHASE 10 — Polish & QA

### Performance
- [ ] **T-118** Audit all providers — ensure heavy queries run on background isolate
- [ ] **T-119** Add `const` constructor to all stateless widgets
- [ ] **T-120** Profile startup time on physical device (target < 1s)
- [ ] **T-121** Profile dashboard load time (target < 300ms)

### Tests
- [ ] **T-122** Widget test: `QuantaneCard` renders without overflow
- [ ] **T-123** Widget test: `FuelEntryCard` shows correct mileage delta color
- [ ] **T-124** Widget test: `SpeedGauge` renders at 0 and 200 KM/H
- [ ] **T-125** Integration test: add fuel entry → verify mileage calculation displayed
- [ ] **T-126** Integration test: start trip → stop → verify trip in history list
- [ ] **T-127** Unit test: `InsightEngine.generate` — all insight branches

### Release
- [ ] **T-128** Set app icons (`flutter_launcher_icons`)
- [ ] **T-129** Set splash screen (`flutter_native_splash`)
- [ ] **T-130** Configure ProGuard rules for release Android build
- [ ] **T-131** Build signed APK: `flutter build apk --release --split-per-abi`
- [ ] **T-132** Build IPA: `flutter build ipa`
- [ ] **T-133** Capture 5 Play Store screenshots (Home, Trips live, Analytics, Fuel history, Vehicle)

---

## Task Count Summary

| Phase | Tasks | Range |
|---|---|---|
| 0 — Bootstrap | 7 | T-001–T-007 |
| 1 — Data Layer | 25 | T-008–T-030 |
| 2 — UI Shell | 14 | T-031–T-044 |
| 3 — Home Dashboard | 12 | T-045–T-056 |
| 4 — Fuel Management | 13 | T-057–T-069 |
| 5 — Trip Tracking | 14 | T-070–T-083 |
| 6 — Analytics | 10 | T-084–T-093 |
| 7 — Vehicles | 9 | T-094–T-102 |
| 8 — Insights | 8 | T-103–T-110 |
| 9 — Settings | 7 | T-111–T-117 |
| 10 — QA & Release | 16 | T-118–T-133 |
| **Total** | **135** | |
