# Quantane — Design Specification

> Visual language, component library, and screen-by-screen UI specification.
> Design philosophy: Glassmorphism × Minimalism · Dark-first · Premium fintech feel.

---

## 1. Design Principles

**Dark first.** Every screen designed for dark mode. Light mode is not in V1 scope.

**Data clarity.** Numbers are the hero. Typography hierarchy makes values scannable in < 1 second.

**Motion with purpose.** Animations exist to communicate state change — not decoration. Every transition should have a reason.

**Honest density.** Cards breathe. No cramming. Generous padding makes data feel premium, not sparse.

**Indian context.** Rupee (₹) as primary currency. Indian fuel station brands. KM as default unit. Fonts that handle Devanagari gracefully if needed in future.

---

## 2. Color System

```dart
// Backgrounds
kBgColor           = Color(0xFF0B0F14)   // App background — near black with blue undertone
kCardColor         = Color(0xFF121821)   // Card surface
kCardElevated      = Color(0xFF1A2232)   // Slightly elevated card (modals, sheets)
kDividerColor      = Color(0xFF1E2A3A)   // Subtle dividers

// Brand
kPrimaryColor      = Color(0xFF3B82F6)   // Blue — interactive elements, active state
kPrimaryMuted      = Color(0x263B82F6)   // Blue at 15% opacity — chart fills, badge bg

// Semantic
kAccentColor       = Color(0xFF22C55E)   // Green — positive delta, success, mileage up
kWarningColor      = Color(0xFFF59E0B)   // Amber — caution, moderate spend
kDangerColor       = Color(0xFFEF4444)   // Red — negative delta, errors, delete

kAccentMuted       = Color(0x1A22C55E)   // Green at 10% opacity
kDangerMuted       = Color(0x1AEF4444)   // Red at 10% opacity

// Typography
kTextPrimary       = Color(0xFFF1F5F9)   // Headings, primary values
kTextSecondary     = Color(0xFF94A3B8)   // Labels, supporting text
kTextTertiary      = Color(0xFF64748B)   // Timestamps, metadata
```

### Gradient Palette
```dart
kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)

kSuccessGradient = LinearGradient(
  colors: [Color(0xFF22C55E), Color(0xFF15803D)],
  ...
)

kCardGlassGradient = LinearGradient(
  colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

---

## 3. Typography

**Font family:** `Inter` (primary) — import via `google_fonts` package.

| Role | Style | Size | Weight | Color |
|---|---|---|---|---|
| Display — hero value | `displayLarge` | 40sp | 700 | kTextPrimary |
| Display — stat value | `displayMedium` | 28sp | 600 | kTextPrimary |
| Headline | `headlineMedium` | 20sp | 600 | kTextPrimary |
| Title | `titleMedium` | 16sp | 600 | kTextPrimary |
| Body | `bodyLarge` | 15sp | 400 | kTextPrimary |
| Body small | `bodyMedium` | 13sp | 400 | kTextSecondary |
| Label / caption | `labelMedium` | 11sp | 500 | kTextTertiary |
| Button | `labelLarge` | 14sp | 600 | kTextPrimary |

**Numeric font feature:** Use `FontFeature.tabularFigures()` on all monetary and distance values for consistent column alignment.

---

## 4. Spacing & Layout

```
Base unit: 4dp

Micro:      4dp   — icon padding, tight gaps
Small:      8dp   — between related items
Medium:     16dp  — standard padding, card inner margin
Large:      24dp  — section spacing, card padding
XLarge:     32dp  — screen-level vertical rhythm
XXLarge:    48dp  — hero section spacing
```

**Screen horizontal padding:** `16dp` on all screens.

**Safe area:** Always respect `MediaQuery.of(context).padding` for top (notch) and bottom (home indicator).

---

## 5. Shape System

```
Card radius:         24dp   (RoundedRectangleBorder)
Sheet radius:        20dp   (top corners only)
Button radius:       12dp
Chip/badge radius:   100dp  (fully rounded pill)
Input radius:        12dp
Icon container:      12dp
```

---

## 6. Component Library

### 6.1 QuantaneCard

```
┌─────────────────────────────┐  ← radius: 24
│  [optional gradient border] │  ← 1dp border, color: 0x1AFFFFFF
│                             │
│   Content (padding: 20dp)   │
│                             │
└─────────────────────────────┘

Background:   kCardColor
Shadow:       BoxShadow(0, 8, 24, kPrimaryColor at 8% opacity)
Border:       optional, default none
Elevation:    via shadow, not Material elevation
```

**Variants:**
- `QuantaneCard.flat` — no shadow, no border (for list items)
- `QuantaneCard.glass` — kCardGlassGradient + frosted border
- `QuantaneCard.colored` — gradient background (hero card)

### 6.2 StatTile

```
┌──────────────────┐
│  [Icon bg]  Icon │  ← 36×36 container, icon 20dp, bg = color at 15%
│                  │
│  42 KM/H         │  ← displayMedium or titleMedium depending on size
│  Avg Speed       │  ← labelMedium, kTextSecondary
│  ↑ +8%           │  ← DeltaBadge (optional)
└──────────────────┘

Padding: 16dp
Background: kCardColor
Radius: 20dp
```

### 6.3 DeltaBadge

```
[ ↑ 8.2% ]   — positive: kAccentColor bg muted, text kAccentColor
[ ↓ 3.1% ]   — negative: kDangerColor bg muted, text kDangerColor
[ — 0.0% ]   — neutral: kTextTertiary bg muted, text kTextTertiary

Padding: 4dp × 8dp
Radius: pill
Font: labelMedium, bold
```

### 6.4 QuantaneFAB (Floating Action Button)

```
Background: kPrimaryGradient
Icon: white, 24dp
Size: 56×56dp
Shadow: 0 8 24 kPrimaryColor at 40%
Radius: 16dp  (squircle feel, not circle)
```

On Live Trip screen: FAB replaced with full-width "Stop Trip" button.

### 6.5 Input Fields

```
Fill: kCardElevated
Border: none (unfocused) / kPrimaryColor 1.5dp (focused)
Radius: 12dp
Padding: 16dp × 14dp (horizontal × vertical)
Label: floats above on focus, kTextSecondary
Error: kDangerColor, appears below field
Prefix text (₹, L, KM): kTextSecondary
```

### 6.6 Bottom Sheet

```
Handle bar: 4×32dp, kDividerColor, centered, 8dp from top
Background: kCardElevated
Top radius: 20dp
Drag to dismiss: enabled
Max height: 85% of screen
```

---

## 7. Screen Specifications

### 7.1 Home Screen

**Layout:** `CustomScrollView` with `SliverList`

```
StatusBar: transparent, light icons

[SliverAppBar]
  ─ Pinned: false, floating: true
  ─ Title: "Quantane" (Inter 600, 18sp) + vehicle name chip (right)
  ─ Background: kBgColor

[HeroSummaryCard]
  ─ Full width, margin: 16dp horizontal
  ─ Background: kPrimaryGradient
  ─ Padding: 24dp
  ─ Layout:
      "Fuel This Month"          ← labelMedium, white 70%
      ₹ 4,250                    ← displayLarge, white
      ─────────────────
      245 KM          28.7 KM/L  ← two columns, titleMedium white
      Distance        Avg Mileage ← labelMedium, white 60%

[SectionHeader] "Quick Stats"
[QuickStatsGrid]
  ─ 2×2 GridView, spacing 12dp
  ─ Each cell: StatTile

[SectionHeader] "This Week"
[WeeklySpendChart]
  ─ Height: 180dp
  ─ fl_chart LineChart
  ─ Line color: kPrimaryColor, width 2dp
  ─ Fill: kPrimaryMuted gradient to transparent
  ─ Dot: 4dp circle, kPrimaryColor
  ─ Grid lines: kDividerColor, dashed
  ─ X labels: "Mon Tue Wed..." kTextTertiary labelMedium
  ─ Y labels: "₹0 ₹500..." kTextTertiary labelMedium

[SectionHeader] "Smart Insights"
[InsightBanner]
  ─ Horizontal ListView of chips
  ─ Each chip: emoji + text, QuantaneCard.flat, scroll

[SectionHeader] "Recent Activity"
[ActivityFeed]
  ─ ListView of ActivityCard (max 5, "See all" link)
```

### 7.2 Fuel Screen

**Layout:** `Scaffold` with FAB

```
[AppBar] "Fuel Log"

[ListView]
  Each item: FuelEntryCard
  ─ Height: ~90dp
  ─ Layout:
      Left:  Date (titleMedium) / Station (bodyMedium, kTextSecondary)
      Right: ₹ cost (titleMedium kPrimaryColor)
             liters + odo (labelMedium kTextSecondary)
  ─ Bottom row: mileage this fill + DeltaBadge vs prev fill
  ─ Swipe left to delete (red danger background)

[FAB] "+" → opens AddFuelSheet

[AddFuelSheet]
  Handle bar
  "Add Fuel Fill" heading (titleMedium, 20dp from handle)
  
  Row: [Cost ₹ ___________] [Liters ___]    ← 60/40 split
  Row: [Odometer KM _______________________]
  Row: [Station ▾ dropdown] 
  Row: [Notes (optional) _________________ ]
  
  [Save Fill] button — full width, kPrimaryGradient, 52dp height, radius 12dp
```

### 7.3 Trips Screen

**Layout:** `Scaffold` with FAB

```
[AppBar] "Trips"

[if no active trip]
  [ListView] of TripCard
    ─ Date, distance (titleMedium), duration
    ─ Avg / Max / Min speed row (StatTile compact)
    
[FAB] → Start Trip → LocationPermission check → LiveTripScreen

[LiveTripScreen] — full screen
  Background: kBgColor
  
  [SpeedGauge] — center of screen
    Size: 260dp diameter
    Arc: 220° sweep, from 225° to 45° (bottom gap)
    Track: kDividerColor, 12dp stroke
    Value arc: kPrimaryColor → kAccentColor gradient, 12dp
    Center:
      Current speed value (displayLarge, 44sp, white)
      "KM/H" (labelMedium, kTextSecondary)
    
  Below gauge (16dp gap):
    3-column row:
      Top Speed | Distance | Duration
      (titleMedium | bodyMedium label)
  
  Bottom sheet style panel (always-open, 200dp height):
    "Trip in progress" dot indicator (pulsing green dot + text)
    [Stop Trip] full-width button, kDangerColor, 52dp
```

### 7.4 Analytics Screen

**Layout:** `NestedScrollView`

```
[AppBar] "Analytics" — collapsible

[Tab Bar] — Week / Month / Year
  ─ Indicator: kPrimaryColor pill underline
  ─ Unselected: kTextSecondary
  ─ Selected: kTextPrimary

[Tab View content — scrollable]
  [SpendingChart Section]
    ─ Week: BarChart (7 bars)
    ─ Month: LineChart (daily)
    ─ Year: BarChart (12 months)
    ─ Height: 200dp
    ─ Tooltips on tap: shows date + ₹ value

  [MileageAnalysisSection]
    ─ Row: Best [32.1 KM/L] / Avg [28.7] / Worst [22.0]
    ─ Mini trend line below (60dp height, last 10 fills)

  [SpeedAnalysisSection]
    ─ BarChart: trips on x, avg speed on y (last 10 trips)
    ─ Max speed markers: dot overlay

  [CostAnalysisSection]
    ─ Total spend card (large number)
    ─ Cost/KM trend line
    ─ Monthly avg bar (last 6 months)
```

### 7.5 Vehicle Screen

```
[AppBar] "My Vehicles" + [+] icon button

[ListView] of VehicleCard
  ─ Left: vehicle type icon in colored container
  ─ Center: name (titleMedium), fuel type + tank capacity (bodyMedium)
  ─ Right: [Active] pill badge (kAccentColor) or tap to set active
  ─ Tap → edit sheet

[AddVehicleSheet]
  Name field
  Type segmented control: 🏍 Bike | 🚗 Car | 🚛 Truck
  Fuel type segmented: Petrol | Diesel | CNG | EV
  Tank capacity (L) field
  Purchase date picker
  Initial odometer field
  [Save Vehicle] button
```

### 7.6 Settings Screen

```
[AppBar] "Settings"

[Section: Vehicle]
  Active vehicle row → links to /vehicles

[Section: Preferences]
  Currency symbol row — ₹ / $ / € / £ (action sheet picker)
  Distance unit row — KM / Miles (toggle)

[Section: Data]
  Export data row → share sheet
  Clear all data row → double-confirm dialog (kDangerColor)

[Section: About]
  App version row (auto-read)
  Privacy policy row
```

---

## 8. Navigation & Transitions

### Bottom Navigation
```
Tab order: Home · Fuel · Trips · Analytics · Settings
Active icon: filled variant, kPrimaryColor
Inactive icon: outlined variant, kTextTertiary
Label: always visible, 10sp
Background: kCardColor with top border kDividerColor 1dp
Height: 60dp + safe area bottom
```

### Page Transitions
- **Shell tab switch:** `FadeTransition`, 150ms
- **Push routes (detail screens, sheets):** Default `CupertinoPageRoute` slide-up feel
- **Bottom sheets:** default `showModalBottomSheet` with `isScrollControlled: true`
- **Live trip screen:** scale + fade in (feels like launching)

---

## 9. Charts Style Guide (fl_chart)

**Global chart defaults:**
```dart
FlDefaults(
  lineChartData: LineChartData(
    gridData: FlGridData(
      drawVerticalLine: false,
      getDrawingHorizontalLine: (_) => FlLine(
        color: kDividerColor,
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    ),
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: ...,  // show ₹ values
      bottomTitles: ... // show date labels
    ),
  ),
)
```

**Bar chart:** `rodWidth: 20dp`, `borderRadius: 6dp`, `gradient: kPrimaryGradient`

**Line chart:** `isCurved: true`, `curveSmoothness: 0.35`, `dotData: FlDotData(show: false)` (dots only on touch)

**Tooltip:** `kCardElevated` background, `kPrimaryColor` indicator dot, `kTextPrimary` value

---

## 10. Iconography

**Library:** `lucide_icons` (consistent stroke weight, modern)

| Screen/Element | Icon |
|---|---|
| Home tab | `LucideIcons.home` |
| Fuel tab | `LucideIcons.fuel` |
| Trips tab | `LucideIcons.route` |
| Analytics tab | `LucideIcons.barChart2` |
| Settings tab | `LucideIcons.settings` |
| Add action | `LucideIcons.plus` |
| Mileage/KM/L | `LucideIcons.gauge` |
| Cost/₹ | `LucideIcons.indianRupee` |
| Speed | `LucideIcons.zap` |
| Distance | `LucideIcons.mapPin` |
| Duration | `LucideIcons.clock` |
| Vehicle (bike) | `LucideIcons.bike` |
| Vehicle (car) | `LucideIcons.car` |
| Fuel station | `LucideIcons.building` |
| Insight | `LucideIcons.lightbulb` |
| Delete | `LucideIcons.trash2` |
| Edit | `LucideIcons.pencil` |

**Icon sizes:**
- Tab bar: 22dp
- Card icons (in colored container): 18dp
- Inline text icons: 14dp
- FAB: 24dp

---

## 11. Motion Design

| Interaction | Duration | Curve |
|---|---|---|
| Tab switch fade | 150ms | `Curves.easeOut` |
| Card appear | 200ms | `Curves.easeOutCubic` |
| Sheet open | 350ms | `Curves.easeOutQuart` |
| Speed gauge update | 300ms | `Curves.easeInOutCubic` |
| Chart animate in | 600ms | `Curves.easeOutQuart` |
| Delta badge count-up | 800ms | `Curves.decelerate` |
| FAB scale on press | 100ms | `Curves.easeIn` |

**Staggered list animations:** `AnimationStaggered` — each card delays by `index * 50ms`, max 300ms total delay.

---

## 12. Empty States

**Design pattern:** Icon (48dp, kTextTertiary) → Title (titleMedium) → Subtitle (bodyMedium, kTextSecondary) → CTA button (optional)

| Screen | Icon | Title | Subtitle |
|---|---|---|---|
| No fuel entries | `LucideIcons.fuel` | No fills logged yet | Tap + to record your first fuel fill |
| No trips | `LucideIcons.route` | No trips yet | Tap the button below to start your first ride |
| No vehicles | `LucideIcons.car` | Add your vehicle | Set up your vehicle to start tracking |
| Analytics (no data) | `LucideIcons.barChart2` | Not enough data | Add at least 2 fuel fills to see analytics |

---

## 13. Accessibility

- Minimum touch target: 44×44dp on all interactive elements
- Contrast ratio: all body text ≥ 4.5:1 against backgrounds
- `Semantics` labels on all icon-only buttons
- `MediaQuery.textScaleFactor` respected (no hardcoded pixel font sizes in widgets — use theme)
- No color-only encoding — all deltas also have arrow icon (↑ / ↓)
