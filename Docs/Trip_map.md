Proposed Product Direction
Remove Analytics

Current Analytics page:

Total distance
Average speed
Trip count
Generic stats

These are nice but boring.

Users care much more about:

"Where did I ride?"

than

"I rode 82km this month"

So I would replace Analytics entirely with:

Trips → Ride History

Every completed trip becomes a visual journey.

New Trips Experience

Instead of:

Trip #23
Distance: 15.2 km
Duration: 22 min

Show:

┌────────────────────┐
│ Map Thumbnail      │
│                    │
│ Start ●───────■ End│
└────────────────────┘

Home → Office

15.2 km
22 min
Max Speed 62 km/h

June 14, 2026

Like the image you attached.

Architecture

Current

GPS
 ↓
TripPoints
 ↓
Distance
 ↓
History List

New

GPS
 ↓
TripPoints
 ↓
Route Builder
 ↓
Map Snapshot
 ↓
Trip Detail Page
Phase 1 (100% Free)

This is what I would ship first.

No Google Maps.

No Mapbox.

No paid APIs.

No billing.

Use Flutter Map

Package:

flutter_map

Map source:

OpenStreetMap

Tile URL:

https://tile.openstreetmap.org/{z}/{x}/{y}.png

Free.

Open source.

No credit card.

No billing account.

No usage tracking.

Perfect for a startup with zero budget.

Database Changes

Your Trip model currently stores:

List<TripPoint> points

Keep it.

Add:

class SavedTrip {
  ...
  
  String? startAddress;
  String? endAddress;

  double minLat;
  double maxLat;

  double minLng;
  double maxLng;

  String? snapshotPath;
}
Trip Stop Flow

Current:

User Stops Trip
 ↓
Save Session
 ↓
Done

New:

User Stops Trip
 ↓
Finalize Session
 ↓
Generate Route Metadata
 ↓
Generate Snapshot
 ↓
Save Trip
 ↓
Show Trip Detail
Route Metadata Generation

Immediately after stop:

Calculate:

Start Point
End Point

from

points.first
points.last

Calculate:

Bounding Box

from all coordinates.

Reverse Geocoding

Need:

Home
Office

Chennai
Coimbatore

Anna Nagar
T Nagar

instead of

13.0827
80.2707

Use:

Nominatim

OpenStreetMap geocoder.

Free.

Request:

https://nominatim.openstreetmap.org/reverse

Example:

lat=13.0827
lon=80.2707

Response:

Anna Nagar
Chennai
Tamil Nadu

Store:

startAddress
endAddress
Trip Detail Page

New screen:

Trip Details

Layout:

────────────────────
Route Map
────────────────────

Start
Anna Nagar

End
T Nagar

Distance
15.2 km

Duration
23 min

Avg Speed
38 km/h

Max Speed
62 km/h
Route Drawing

Use your existing coordinates.

Convert:

TripPoint

to

LatLng

Then:

Polyline(
  points: routePoints,
)

This draws the trip path.

No API required.

Route Simplification

Some rides may generate:

5000+
GPS points

Rendering all of them is wasteful.

Before saving:

Apply

Douglas-Peucker Algorithm

using package:

latlong2

or custom implementation.

Example:

5000 points
 ↓
250 points

Visually identical.

Much smaller storage.

Trip Thumbnail Generation

This is the killer feature.

Generate a static image after trip completion.

Store:

snapshotPath

Example:

/app_data/trips/trip_123.png

Displayed inside trip history.

Exactly like your screenshot.

How to Generate Thumbnail

Render hidden FlutterMap:

FlutterMap

with:

PolylineLayer

Take screenshot using:

screenshot

package.

Save locally.

Trip List

Instead of today's list:

Trip 1
Trip 2
Trip 3

Show:

┌───────────────┐
│ Route Image   │
└───────────────┘

Home → Office

15.2 km
22 min

14 June 2026

Much more premium.

Trip Insights (Free)

Since you already have coordinates:

Calculate:

Top Speed
maxSpeed
Moving Time

Exclude stops.

Idle Time
duration - movingDuration
Stops

Detect:

speed < 3km/h
for > 2 mins

Show:

2 Stops
Route Replay (Future)

You already have timestamps.

Later:

▶ Replay Trip

Animate marker.

Start
 ↓
Move
 ↓
Move
 ↓
End

No extra data needed.

Your current GPS storage already supports this.

Recommended Folder Structure
features/
└── trips/
    ├── data/
    │   ├── trip_repository.dart
    │   ├── geocoding_service.dart
    │   ├── route_snapshot_service.dart
    │
    ├── models/
    │   ├── trip_point.dart
    │   ├── trip_route.dart
    │
    ├── presentation/
    │   ├── trips_screen.dart
    │   ├── trip_detail_screen.dart
    │   ├── widgets/
    │
    └── services/
        ├── trip_tracking_service.dart
        ├── route_processing_service.dart
What I Would Build First
Sprint 1
Remove Analytics
Add Trip Detail Page
Draw route using FlutterMap + OpenStreetMap
Show Start → End addresses
Show route polyline
Sprint 2
Generate trip thumbnails
Improve trip cards
Add ride statistics
Sprint 3
Route replay
Stop detection
Favorite routes
Export GPX

This approach stays completely free, uses the GPS data you're already collecting, requires no Google Maps billing, and turns Trips into a feature users will actually open repeatedly instead of a passive statistics page.