# Trips Page

The Trips page is the trip tracking hub. It is where the user prepares permissions, starts tracking, sees active trip availability, and reviews trip history for the selected vehicle.

## What the page shows

The Trips screen includes:

1. A permission banner for location and notifications.
2. A trip summary card for the active vehicle.
3. A recent trips list.
4. A floating action button for starting or resuming a trip.
5. A vehicle selector chip so the user can switch the tracked vehicle without leaving the page.

## How it works

The page uses a permission snapshot to determine whether location is ready for tracking. If location is blocked, the UI explains what is missing and offers the correct recovery action, such as opening location settings or app settings.

The page also reads the trip history stream for the active vehicle and updates the summary card with trip count, distance, duration, and average speed.

When the user starts a trip, the page hands control to the trip tracking service, which listens to GPS coordinates in the foreground task.

## Purpose

This page is the operational center for trip activity. It is the first place the user interacts with before tracking begins, and it is also the place they return to for trip history and recovery actions.
