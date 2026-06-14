# Home Page

The Home page is the dashboard of the app. It gives the user a quick overview of their vehicle usage, recent performance, and high-level insights.

## What the page shows

The Home screen combines several dashboard sections:

1. A summary card for the currently selected vehicle.
2. A quick-stats grid for mileage, trips, fuel spend, and related metrics.
3. Smart insight banners that highlight useful patterns or summaries.
4. A mileage and speed section for quick trend viewing.

The page also includes the vehicle selector chip in the app bar so the user can switch the active vehicle without leaving the dashboard.

## How it works

Home reads its data from dashboard providers, then conditionally renders empty states when the app does not yet have enough data.

When no summary or stats are available, the page shows guidance text explaining that trips and fuel entries are needed before the dashboard becomes meaningful.

## Purpose

This page is designed as a starting point after launch. It gives a quick summary of activity and helps the user see whether the selected vehicle has enough data to produce useful fuel and trip insights.
