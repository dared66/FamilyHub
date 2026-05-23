# FamilyHub — Project Status

## Overview

Android wall-display app. Three-page layout: Calendar, Tasks, Photos. Built with Flutter 3.44.0, Riverpod, local mock services.

**Path:** `/tmp/FamilyHub`
**Package:** `io.familyhub.app`

---

## ✅ Working

### Rendering
- Flutter renders correctly on emulator (Impeller disabled via AndroidManifest)
- Light theme with visible text (#F5F5F5 background, #202124 text)
- 2400x1080 landscape display
- PageView with 3 swipeable pages

### Navigation
| Method | Status |
|--------|--------|
| Swipe left/right | ✅ PageView transitions between Calendar/Tasks/Photos |
| Page dots (bottom) | ✅ Tappable, 32px hit targets, skip to page |
| Status bar taps | ✅ FAMILYHUB / Tasks / Photos labels at top |

### Calendar Page
- Blue header with "FAMILYHUB", month, event count
- Event cards with blue time circles, title, date, calendar chip
- Tappable events → floating SnackBar (56px bottom margin, not overlapping dots)
- Scrollable event list (ClampingScrollPhysics)
- `calendarNotifierProvider` → `CalendarService` (mock, returns 8 fake events)

### Tasks Page
- Tabbed view: Chores / Shopping / Meal Plan / General
- Each task: checkbox, title, due date
- Toggle checkbox calls `tasksNotifierProvider.notifier.toggleTask()`
- `tasksNotifierProvider` → `TasksService` (mock, returns ~3-5 tasks per list)

### Photos Page
- Skeleton placeholder with "Photos" text

### Services (Mock)
| Service | File | Data |
|---------|------|------|
| CalendarService | `calendar_service.dart` | 3 calendars, 8 events/month |
| TasksService | `tasks_service.dart` | 4 lists, 3-5 tasks each |
| WeatherService | `weather_service.dart` | Seattle 55°F, mostly cloudy |

### Hermes Config
- Delegation: `custom:qwen3-coder-30b-local` → local Qwen3-Coder-30B
- Subagent auto-approve: on
- OMLX server: port 8000, `skip_api_key_verification: true`

---

## ❌ Known Issues

### Clock
- StatusBar shows live clock but format depends on subagent's implementation
- Verify: `widgets/status_bar.dart`

### Tasks Page UX
- Tab tap changes list but no highlight animation on active tab
- No "add task" button on Tasks page yet

### Photos Page
- V2 feature — no Google Photos integration yet
- Shows placeholder text

### Event Creation
- CalendarPage has FAB removed (shown in earlier version)
- No "add event" flow wired in current simplified CalendarPage

### Theme Inconsistencies
- `theme.dart` was modified by subagent — may have mixed dark/light references
- Some hardcoded colors in widgets still reference dark theme constants

### Impeller
- Disabled via AndroidManifest — re-enable on real hardware (ApoloSign)

### No Google OAuth
- `google-services.json` not present
- All services are mocked — no real Calendar/Tasks/Photos API calls

---

## 📋 Tasks

1. **Month grid** — Restore `MonthGrid` widget integration into CalendarPage
2. **Agenda view** — Restore `AgendaList` with selected-day filtering
3. **Weather strip** — Wire WeatherNotifier into StatusBar display
4. **Add Event flow** — FAB + AddEventSheet bottom sheet
5. **Add Task flow** — FAB + AddTaskSheet on Tasks page
6. **Task deletion** — Wire delete button in TaskTile
7. **Page transition animations** — Smooth slide between pages
8. **ApoloSign deployment** — Release build, Impeller re-enable, test on hardware
9. **Google OAuth** — Create `google-services.json`, wire live Calendar/Tasks APIs

---

## Tech Stack

| Component | Version |
|-----------|---------|
| Flutter | 3.44.0 |
| Dart | 3.12.0 |
| Riverpod | ^2.6.1 |
| google_sign_in | ^6.2.2 |
| googleapis | ^13.0.0 |
| flutter_secure_storage | ^9.2.2 |
| intl | ^0.19.0 |
| http | ^1.2.1 |
| encrypt | ^5.0.3 |

## Key Files

| Path | Role |
|------|------|
| `lib/main.dart` | App shell with PageView + navigation |
| `lib/core/const.dart` | Color constants, sizes, durations |
| `lib/core/theme.dart` | AppTheme.darkTheme |
| `lib/pages/calendar_page.dart` | Calendar event list page |
| `lib/pages/dashboard_page.dart` | Tasks tabbed dashboard |
| `lib/pages/photos_page.dart` | Photos placeholder |
| `lib/services/calendar_service.dart` | Mock CalendarService + provider |
| `lib/services/tasks_service.dart` | Mock TasksService + provider |
| `lib/services/weather_service.dart` | Mock WeatherService + provider |
| `lib/widgets/status_bar.dart` | Clock + navigation bar |
| `lib/widgets/page_dot_indicator.dart` | Tappable page dots |
| `lib/widgets/task_tile.dart` | Task item checkbox |
| `android/app/src/main/AndroidManifest.xml` | Kiosk perms + Impeller disable |
| `docs/STATUS.md` | This file |

---

*Updated: 2026-05-23*
