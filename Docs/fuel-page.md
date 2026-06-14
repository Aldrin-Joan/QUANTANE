# Fuel Page

The Fuel page is the fuel log for the selected vehicle. It lets the user track fill-ups, review previous entries, and see fuel-related totals.

## What the page shows

The Fuel screen includes:

1. A summary hero card with total spend, total liters, and mileage overview.
2. A list of fuel entries for the active vehicle.
3. A floating action button for adding a new fuel entry.

The page also includes the vehicle selector chip so fuel history is filtered to the active vehicle.

## How it works

Fuel data is loaded through the fuel history provider and rendered as either a list of entries or an empty state if no fills exist yet.

Long-pressing a fuel entry opens an action sheet where the user can edit or delete that entry.

## Purpose

This page is where the app records fuel purchases and computes fuel usage metrics over time. It supports cost tracking, mileage visibility, and data cleanup on a per-entry basis.
