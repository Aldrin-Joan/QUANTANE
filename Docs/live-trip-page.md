# Live Trip Page

The Live Trip page is the active tracking view shown while a trip is running. It focuses on live speed, trip duration, and stop control.

## What the page shows

The screen includes:

1. A speed gauge with digital and analog display modes.
2. Live speed, maximum speed, distance, and duration stats.
3. A trip status indicator.
4. A Stop Trip button.

## How it works

The screen listens to the trip tracking provider for the current active session. If no active session exists, it redirects back to the Trips page.

The page keeps the device awake while tracking is active and updates the elapsed duration every second.

## Purpose

This page is the live monitoring surface for a trip in progress. It is intended for the driver to watch current speed and stop the trip when the journey is complete.
