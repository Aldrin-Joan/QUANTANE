# Vehicles Page

The Vehicles page is where the user manages the list of vehicles in the app and selects the active one.

## What the page shows

The screen includes:

1. A list of saved vehicles.
2. A visual indicator for the active vehicle.
3. A floating action button for adding a new vehicle.

## How it works

Vehicles are loaded from the vehicle repository and rendered in a simple list.

Tapping a vehicle makes it the active vehicle for the rest of the app, which affects Home, Fuel, Trips, and other vehicle-scoped views.

If no vehicles exist yet, the screen shows an empty state.

## Purpose

This page is the source of truth for vehicle selection. Any trip or fuel data shown elsewhere is filtered against the active vehicle chosen here.
