# Quantane

Quantane is a premium, offline-first vehicle analytics and fuel intelligence app built with Flutter. It helps riders and drivers track fuel expenses, mileage efficiency, trip performance, speed analytics, and vehicle costs through dashboards, real-time GPS tracking, and data visualizations. The product is designed around a dark-first, glassmorphism-inspired interface with a strong focus on data clarity and fast, private local storage.

## Product Vision

Quantane turns everyday driving data into actionable insights while staying fully functional without an internet connection. The app is optimized for the Indian context with rupee-first currency handling, kilometer-based distance tracking, and fuel station workflows that match local usage patterns.

## Design Direction

The UI follows a dark-first premium fintech aesthetic:

- Backgrounds use near-black blue-tinted surfaces.
- Cards use layered glassmorphism with subtle borders and shadows.
- Typography emphasizes large, scannable numeric values.
- Motion is reserved for meaningful state changes.
- Spacing is generous to keep dense data readable.

Primary design tokens from the spec include:

- Background: `#0B0F14`
- Card surface: `#121821`
- Primary blue: `#3B82F6`
- Success green: `#22C55E`
- Warning amber: `#F59E0B`
- Danger red: `#EF4444`
- Primary text: `#F1F5F9`
- Secondary text: `#94A3B8`

## Core Stack

The implementation plan centers on:

- Flutter and Dart
- Riverpod for state management
- go_router for navigation
- drift and SQLite for offline persistence
- fl_chart for analytics visualizations
- geolocator for live trip tracking
- shared_preferences for lightweight local settings

## Planned Feature Areas

The app is organized into these major areas:

- Home dashboard with fuel spend, mileage, quick stats, weekly charts, and recent activity
- Fuel management with history, add/edit flows, and mileage calculations
- Trip tracking with live GPS, speed monitoring, and trip summaries
- Analytics with weekly, monthly, and yearly views
- Vehicle management with active vehicle selection and local persistence
- Smart insights for mileage, spend, and usage trends
- Settings for currency, distance units, export, and data reset

## Architecture Overview

The implementation plan uses a layered structure:

- `lib/core` for theme, routing, and shared utilities
- `lib/data` for drift tables, database wiring, and repositories
- `lib/domain` for models and analytics aggregates
- `lib/features` for screen-level UI and feature-specific widgets

The data layer is designed around local-first repositories so the app can compute mileage, cost per kilometer, monthly spend, and activity feeds without requiring a backend.

## Roadmap

The current plan is split into phases:

1. Project bootstrap and dependency setup
2. Data layer and offline persistence
3. Core UI shell and shared widgets
4. Home dashboard
5. Fuel management
6. Trip tracking
7. Analytics
8. Vehicle management
9. Smart insights
10. Settings
11. Polish, testing, and release preparation

## Status

This repository currently contains the Flutter app scaffold and supporting Android project files. The README now reflects the intended product direction and implementation scope described in the design, implementation plan, and task tracker.

## References

- [Design specification](Docs/design%20(1).md)
- [Implementation plan](Docs/implementation_plan.md)
- [Task tracker](Docs/task.md)
