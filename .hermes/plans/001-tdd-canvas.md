# FamilyHub — TDD Canvas: Calendar & Tasks

**Scope**: Calendar Page (Page 1), Tasks Dashboard (Page 2), AuthService, WeatherService.  
**Deferred**: Photos Page (Page 3), Meal Plan, Mac Mini hooks.  
**Flutter 3.44.0 / Dart 3.12.0 / Riverpod**

---

## Architecture Decision (MVP defaults)

| Question | Decision |
|---|---|
| Meal plan structure | One Google Tasks list, one task per day titled "Mon: ..." |
| Family tasks access | Family adds dummy account as secondary in Google Tasks app |
| Photos scope | All photos on dummy account (shared album optional later) |
| Calendar write target | Dummy account primary calendar |
| Auth polling fallback | 5-min polling for Calendar, 60s for Tasks (as per TDD) |
| State mgmt | Riverpod AsyncNotifierProvider per domain |

---

## Task Decomposition

### Phase 0 — Project Scaffolding (serial, 1 subagent)

| ID | Task | Dependencies |
|----|------|--------------|
| 0.1 | Scaffold Flutter project: `pubspec.yaml` with all deps (google_sign_in, googleapis, flutter_riverpod, encrypt, shared_preferences_secure, http, intl). Set up project structure: `lib/` with `core/`, `models/`, `services/`, `auth/`, `pages/`, `widgets/`. Create `main.dart`, `app.dart` (Riverpod scope), `const.dart` (API endpoints, colors, intervals). | — |

### Phase 1 — Foundation (parallel, 5 subagents)

| ID | Task | Dependencies |
|----|------|--------------|
| 1.1 | **Models** — `FamilyEvent`, `TaskItem`, `TaskList`, `WeatherData`. Plain Dart classes with `fromJson`, `toJson`, equality, copyWith. | 0.1 |
| 1.2 | **AuthService** — `google_sign_in` wrapper, silent sign-in on launch, token refresh logic, `EncryptedSharedPreferences` persistence for refresh token. `AuthGate` widget. | 0.1 |
| 1.3 | **WeatherService** — Open-Meteo client (no auth), `WeatherNotifier` (Riverpod), 30-min interval support, offline last-known-fallback with staleness flag. | 0.1 |
| 1.4 | **CalendarService** — Calendar API client, `calendarList.list`, `events.list` (7d past / 60d future), `events.insert`. `CalendarNotifier` (Riverpod), 5-min polling, color mapping from calendarList entries. | 0.1, 1.2 |
| 1.5 | **TasksService** — Tasks API client, `tasklists.list`, `tasks.list`, `tasks.insert`, `tasks.patch (complete)`, `tasks.delete`. `TasksNotifier` (Riverpod), 60s polling, optimistic UI support. | 0.1, 1.2 |

### Phase 2 — UI (parallel, 4 subagents)

| ID | Task | Dependencies |
|----|------|--------------|
| 2.1 | **Theme + Constants** — Dark theme (#121212 bg, #1A73E8 accent, #34A853 completed). Inter/Roboto font. Theme data, text styles, color tokens. `StatusBar` widget (time, date, weather). Page dot indicator. | 0.1 |
| 2.2 | **CalendarPage** — Left panel: month grid (7-col Mon-Sun, dots for events, tap date, swipe months). Right panel: agenda list (color bar, time, title, truncated). FAB + `AddEventSheet` bottom sheet. Multi-calendar color coding. | 1.3, 1.4, 2.1 |
| 2.3 | **AddEventSheet** — Bottom sheet (60% height). Fields: title (req), date, start/end time, calendar selector dropdown, notes. Saves via Calendar API. | 1.4 |
| 2.4 | **TasksPage** — Dashboard layout (landscape). Left col: task list tabs (Chores, Shopping, General) with checkboxes, checkboxes toggle completion (optimistic), strikethrough completed. Right col: Shopping list + add item inline. FABs for adding. Weather strip below tasks. | 1.3, 1.5, 2.1 |

### Phase 3 — Integration (serial, 1 subagent)

| ID | Task | Dependencies |
|----|------|--------------|
| 3.1 | **App Integration** — Wire `App` widget: swipeable PageView (3 pages, dots indicator), embed CalendarPage, TasksPage, PhotosPageSkeleton. Verify all Riverpod providers wire through. Add loading/error states. Verify watch/channels for Calendar. One full e2e build test (`flutter build apk`). | All Phase 0-2 |

---

## Parallelism Graph

```
0.1 ──► 1.1 ─────────────────────────────────────────────────┐
         1.2 ──► 1.4 ──► 2.2 ──►                            │
0.1 ──► 1.3 ──► 2.1 ──► 2.2 ──► 2.3 ──► 2.4 ──► 3.1 ──────┤
         1.5 ──► 2.4 ───────────────────────────────────────┘
```

- **Phase 1**: 5 tasks in parallel (1.1, 1.2, 1.3, 1.4, 1.5)
- **Phase 2**: 4 tasks in parallel (2.1, 2.2, 2.3, 2.4) — but 2.1 should start first since others depend on it
- **Phase 3**: 1 serial integration task

**Total subagents**: 11

---

## Output Location

All code goes into `/tmp/FamilyHub/lib/` structure matching the TDD's architecture. Each subagent writes directly to the repo path.

---

## Notes for Subagents

- All code must be production-ready, no stubs
- Error handling required on every API call
- Loading states everywhere (shimmer or spinner)
- Use `async/await` with proper error boundaries
- Riverpod `AsyncNotifierProvider` pattern for all services
- Landscape orientation only (15:9)
- No keyboard fonts — bundle Inter or use system Roboto
- API endpoints and intervals in `core/const.dart`
