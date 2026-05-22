Family Hub

Technical Design Document

Android APK  |  Flutter  |  Google Workspace APIs

v0.1 — May 2026

1. Overview

Family Hub is a self-contained Android APK designed to run permanently on an ApoloSign wall display. It replaces the ApoloSign proprietary launcher with a slick, always-on family dashboard backed entirely by Google Workspace APIs. There is no dependency on any home server — the app is fully self-sufficient on the device.

Target device

ApoloSign (Android, landscape orientation)

Framework

Flutter 3.x — compiled to a signed release APK

Primary account

Dedicated dummy Google account on device (airgapped from personal accounts)

Auth model

OAuth2 via google_sign_in package; refresh token in EncryptedSharedPreferences

External dependencies

Google Calendar API, Google Tasks API, Google Photos Library API, Open-Meteo (weather, no auth)

Mac Mini dependency

None — optional automation hooks added later as additive, failure-tolerant layer

1.1  Design Principles

Never requires re-authentication after initial setup

Survives device reboot with no user interaction

No white-label or proprietary cloud services

Wife-facing UI must be polished — no developer aesthetics

Mac Mini outage must be invisible to the display

All write operations (add event, add task) reachable from the wall display

2. Architecture

2.1  High-Level Diagram

The APK is the sole runtime. It holds OAuth credentials and communicates directly with Google APIs. Open-Meteo is called without authentication. The ApoloSign device runs the app in a kiosk-style full-screen mode pinned via Android's App Pinning or Device Owner profile.

Runtime Architecture

ApoloSign Device

Flutter APK running full-screen, landscape. Android App Pinning prevents accidental exit. Auto-restarts on crash via a watchdog receiver.

Google Calendar API

OAuth2 read/write. Dummy account has shared access to all family member calendars (read) plus its own calendar (write). Events fetched on launch + every 5 min polling. Push notifications via Calendar watch channels for real-time updates.

Google Tasks API

OAuth2 read/write. All task lists owned by dummy account. Family members add dummy account as secondary in Google Tasks app on their phones to view/edit shared lists.

Google Photos Library API

OAuth2 read-only. Fetches recent photos for ambient slideshow page. Cached locally for 24 hrs to reduce API calls.

Open-Meteo

Free, no API key. Called on app launch and every 30 min. Current conditions + 7-day forecast for Seattle/PNW.

Mac Mini (future, optional)

POST /hook endpoint on the APK accepts automation payloads from OpenClaw or Home Assistant. Failure of Mac Mini does not affect core display. Hooks add notifications and dynamic content overlays only.

2.2  Authentication Architecture

Authentication is performed once on initial device setup. After that it is fully silent and persistent.

Initial auth flow

App launches Chrome Custom Tab via google_sign_in. User signs into dummy Google account. Consents to Calendar, Tasks, Photos scopes.

Token storage

Refresh token written to Android EncryptedSharedPreferences (AES-256, tied to device hardware key). Survives reboots, app updates, and process kills.

Access token refresh

google_sign_in silently refreshes access tokens (1hr TTL) before each API call. No UI shown. Falls back to stored refresh token if in-memory token is stale.

Expiry risk

None. OAuth consent screen kept in Testing mode. Dummy account added as explicit test user. Test-mode tokens for listed users do not expire. Limit: 100 test users (irrelevant for this use case).

Revocation risk

Google revokes refresh tokens only after 6 months of non-use. App polls APIs every 5 min — this will never trigger.

Re-auth trigger

Only if: (a) app is uninstalled and reinstalled, (b) dummy account password changed, or (c) Google Cloud project deleted. All are deliberate admin actions.

Scopes requested

calendar (read/write), tasks (read/write), photoslibrary.readonly

3. Screen Architecture

The app is a single full-screen view with three horizontally swipeable pages. A persistent dot indicator at the bottom center shows current page. A thin top status bar shows time, date, and weather summary on all pages. Swipe left/right to navigate.

Page 1 — Calendar

Primary view. Full-screen monthly calendar + today agenda panel.

Page 2 — Dashboard

Tasks, shopping list, meal plan, weather detail.

Page 3 — Photos

Full-screen ambient photo slideshow from Google Photos.

3.1  Global Chrome

Top status bar (32dp height): current time (left), date (center), weather icon + temp (right)

Status bar background: semi-transparent dark overlay — visible over all pages

Page indicator: three dots, bottom center, 8dp diameter, animated on swipe

No navigation bar, no system UI — full immersive mode

Font: Inter or Roboto (bundled in APK — no network font loading)

Color palette: dark background (#121212), white primary text, Google Blue (#1A73E8) accent, Google Green (#34A853) for completed states

3.2  Page 1 — Calendar

Page 1 — Calendar  [Landscape 15:9]

Left Panel (40%): Month View

  Month name + year header

  7-column grid, Mon–Sun

  Today highlighted (filled circle)

  Dots below dates with events

  Multi-calendar color coding

  Tap date → selects it

  Swipe left/right → prev/next month

Right Panel (60%): Agenda

  Selected date header (large)

  Scrollable list of events for day

  Each event: color bar | time | title

  Multi-line titles truncated at 2 lines

  All-day events at top of list

  FAB bottom-right: + Add Event

  Tap event → detail bottom sheet

3.2.1  Add Event Flow

FAB tap opens bottom sheet (slides up from bottom, 60% screen height)

Fields: Title (required), Date (pre-filled to selected date), Start time, End time, Calendar selector (dropdown of shared calendars), Notes

Save button calls Calendar API events.insert — writes to dummy account's primary calendar

Sheet dismisses on save or tap-outside; calendar refreshes immediately

3.3  Page 2 — Dashboard

Page 2 — Dashboard  [Landscape 15:9]

Left Column (50%)

  TASKS section header

  Active task list selector (tabs)

  Scrollable task list

    Checkbox | title | due date

    Tap checkbox → marks complete

    Completed tasks strike-through, fade

  FAB: + Add Task

  ────────────────

  WEATHER section

  Current temp + condition icon

  High/low for today

  Horizontal 7-day forecast strip

Right Column (50%)

  SHOPPING LIST section header

  Dedicated Google Tasks list

    Checkbox | item name

    Tap to complete (cross off)

    + Add Item inline text field

  ────────────────

  MEAL PLAN section header

  Dedicated Google Tasks list

  Mon–Sun rows, task per day

    Tap row → edit meal for that day

    + Add meal for day

3.3.1  Task List Architecture

Multiple Google Tasks lists rendered as tabs: Chores, Shopping, Meal Plan, General

Left column shows whichever list tab is selected

Shopping and Meal Plan always pinned to right column

All lists owned by dummy account; family edits via Google Tasks app (add dummy account as secondary)

Tasks API polled every 60s (no push notification support in Tasks API)

3.4  Page 3 — Photos

Page 3 — Photos  [Ambient Slideshow]

Layout

Full-screen photo, edge-to-edge, no chrome. Photo fills screen with cover-fit scaling. Subtle dark gradient at bottom for legibility.

Caption bar

Bottom of screen: photo date (left), album name (right). Semi-transparent dark pill background.

Slideshow behavior

Auto-advances every 8 seconds. Cross-fade transition (400ms). Tap left/right thirds of screen to manually step. Tap center to pause/resume.

Photo source

Google Photos Library API — fetches recent 200 photos from dummy account's shared album. Cached locally as JPEG files (24hr TTL). Shuffled on each session.

Offline behavior

If Photos API unavailable, serves from local cache indefinitely until next successful fetch.

4. Google API Integration

4.1  Calendar API

Scope

https://www.googleapis.com/auth/calendar

Read: list calendars

calendarList.list — fetches all calendars the dummy account has access to (own + shared from family members)

Read: fetch events

events.list — per calendar, timeMin=today-7days, timeMax=today+60days, singleEvents=true, orderBy=startTime

Write: create event

events.insert — writes to dummy account primary calendar

Real-time updates

Push notification channel via events.watch per calendar. Webhook receiver runs as a local Android service. Channel TTL = 7 days; auto-renewed by a WorkManager job 24hr before expiry.

Polling fallback

If push channel fails to register (no public HTTPS endpoint), falls back to 5-min polling. Mac Mini hook endpoint can forward calendar webhooks in the future.

Color mapping

Calendar color from calendarList entry mapped to color dot/bar in UI. Up to 8 simultaneous calendars supported in the color legend.

4.2  Tasks API

Scope

https://www.googleapis.com/auth/tasks

Read: list task lists

tasklists.list — fetches all lists for dummy account

Read: fetch tasks

tasks.list per list — showCompleted=false, showHidden=false

Write: create task

tasks.insert with title, notes, due date

Write: complete task

tasks.patch with status=completed

Write: delete task

tasks.delete

Polling interval

60 seconds (Tasks API has no push notification support)

Optimistic UI

Task list updates immediately in UI on user action; API call happens async. On API error, action is rolled back and error toast shown.

4.3  Photos Library API

Scope

https://www.googleapis.com/auth/photoslibrary.readonly

Fetch strategy

mediaItems.list — pageSize=100, fetched on launch and every 24hr via WorkManager

Local cache

Downloaded JPEGs stored in app's private storage (getFilesDir()). Evicted after 7 days.

Shared album

Optional: filter to a specific shared album ID (e.g. 'Family' album). Configured once in app settings.

Rate limits

Photos API: 10,000 requests/day, 75 requests/15 min. Fetch cadence is well within limits.

4.4  Open-Meteo (Weather)

Auth

None — free, no API key required

Endpoint

https://api.open-meteo.com/v1/forecast

Parameters

latitude=47.6062, longitude=-122.3321 (Seattle). current_weather=true, daily=temperature_2m_max,temperature_2m_min,weathercode

Refresh interval

Every 30 minutes via WorkManager

Offline behavior

Last fetched values displayed with a staleness indicator if data is >2hr old

5. Flutter Project Structure

lib/ — Dart source layout

main.dart

App entry point. Initializes Flutter binding, sets immersive full-screen mode, launches AuthGate.

auth/

auth_service.dart — wraps google_sign_in, handles silent sign-in on launch, token refresh, EncryptedSharedPreferences read/write. auth_gate.dart — widget that shows auth screen on first launch, main app thereafter.

pages/

calendar_page.dart, dashboard_page.dart, photos_page.dart — top-level page widgets. Each manages its own data subscription via a Provider/Riverpod notifier.

widgets/

Shared UI components: month_grid.dart, agenda_list.dart, event_card.dart, task_tile.dart, weather_strip.dart, photo_viewer.dart, add_event_sheet.dart, add_task_sheet.dart, status_bar.dart.

services/

calendar_service.dart, tasks_service.dart, photos_service.dart, weather_service.dart — API clients. Each holds its own in-memory cache and exposes streams consumed by page notifiers.

models/

FamilyEvent, TaskItem, TaskList, PhotoItem, WeatherData — plain Dart classes with fromJson constructors.

core/

theme.dart (color tokens, text styles), constants.dart (API endpoints, polling intervals), storage.dart (EncryptedSharedPreferences wrapper).

5.1  State Management

Riverpod — chosen over Provider/Bloc for clean async stream support and compile-time safety

One AsyncNotifierProvider per data domain: CalendarNotifier, TasksNotifier, PhotosNotifier, WeatherNotifier

Notifiers expose StreamController-backed state; services push updates on poll or push notification receipt

UI rebuilds only affected widgets via ref.watch on specific providers

No global state shared across pages except auth state

6. Android Configuration

6.1  Kiosk / Always-On Setup

Enable Android App Pinning (screen pinning) after install — prevents accidental swipe-out

Set app as device owner via ADB for harder lockdown if needed: adb shell dpm set-device-owner

AndroidManifest.xml: android:launchMode=singleInstance, android:screenOrientation=landscape, RECEIVE_BOOT_COMPLETED permission

BroadcastReceiver restarts app on device boot and on app crash

Display timeout: set ApoloSign display sleep to Never (or 30 min with a WorkManager keep-awake job)

Disable system UI: SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)

6.2  Google Cloud Project Setup Steps

One-time setup before first APK build:

Create project at console.cloud.google.com

Enable APIs: Google Calendar API, Tasks API, Photos Library API

OAuth consent screen: External, Testing mode (do not publish)

Add scopes: calendar, tasks, photoslibrary.readonly

Add dummy account email as test user

Create OAuth credential: Android type, package name = com.krupa.familyhub

SHA-1: generate from release keystore after first build, add to credential

No client secret needed for Android OAuth — public client

6.3  Build & Deploy

Keystore

Generate once: keytool -genkey -v -keystore family_hub.jks. Store securely off-device.

Build command

flutter build apk --release --obfuscate --split-debug-info=build/debug

Install

adb install build/app/outputs/flutter-apk/app-release.apk

SHA-1 extraction

keytool -list -v -keystore family_hub.jks | grep SHA1 — add to Google Cloud credential after first build

Updates

Re-install via adb. Auth state persists across updates (EncryptedSharedPreferences retained). No re-auth required.

7. Future: Mac Mini Integration (Optional)

Everything in this section is additive. The APK functions completely without it. The Mac Mini becomes an enhancement layer, not a dependency.

Automation hook endpoint

APK exposes a local HTTP server on port 8765 (accessible on LAN only). POST /hook with JSON payload. Mac Mini, Home Assistant, or OpenClaw posts to this endpoint.

Supported hook actions

show_notification (overlay toast), update_note (push text to whiteboard widget), highlight_event (pulse a calendar event), set_ambient_mode (force photo page)

Calendar push webhooks

Mac Mini acts as HTTPS relay for Google Calendar watch notifications. Registers a public ngrok/Cloudflare tunnel, receives Google pings, forwards to APK via LAN hook. Eliminates 5-min polling for real-time calendar updates.

Resilience

If Mac Mini is offline, APK falls back to polling. No UI change. No error shown. Hook endpoint simply stops receiving; nothing breaks.

8. Open Questions

Meal plan structure

Using a dedicated Google Tasks list (one task per day, titled Mon/Tue/etc). Alternative: dedicated Tasks list per week. Decision deferred to implementation.

Family Tasks access

Family members add dummy account as secondary in Google Tasks app. Needs to be set up on each family member phone once. UX validation pending.

Photos shared album

Decide: show all photos on dummy account, or filter to a specific shared Family album. Shared album requires explicit sharing setup in Google Photos.

Calendar write target

Events created from wall display write to dummy account primary calendar. Family members see these if they have that calendar shared. Confirm this is the desired behaviour.

ApoloSign Android version

Confirm Android API level to ensure EncryptedSharedPreferences and WorkManager compatibility (requires API 23+).

— end of document —