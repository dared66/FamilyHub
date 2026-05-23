/// Month calendar grid with event dots and horizontal swipe navigation.
///
/// Displays a single month in a 7-column grid. Days that contain events
/// show small colored dots beneath the day number. Horizontal swipes move
/// between months.

import 'package:flutter/material.dart';

import '../core/const.dart' as constants;
import '../models/partials.dart';

/// Header labels for the seven week-day columns.
const List<String> _kWeekdayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// Month name used in the month/year header bar.
const List<String> _kMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Configuration for the month grid display.
class MonthGridConfig {
  /// Size of the day-cell square.
  final double cellSize;

  /// Gap between day cells.
  final double gap;

  /// Day number font size.
  final double fontSize;

  /// Dot radius for event indicators.
  final double dotRadius;

  /// Maximum number of event dots shown per cell (overflow is truncated).
  final int maxDots;

  /// Padding inside each cell.
  final double padding;

  const MonthGridConfig({
    this.cellSize = 38.0,
    this.gap = 2.0,
    this.fontSize = 14.0,
    this.dotRadius = 3.5,
    this.maxDots = 3,
    this.padding = 2.0,
  });
}

/// A calendar month grid that supports:
///
/// * Tap on a day to select it.
/// * Swipe left/right to move to the next/previous month.
/// * Event dots colour-coded by calendar color.
class MonthGrid extends StatefulWidget {
  /// The date currently selected in the parent view.
  final DateTime selectedDate;

  /// Month offset from the current month (0 = current, -1 = prev, +1 = next).
  final int monthOffset;

  /// All events to render as dots on the grid.
  final List<FamilyEvent> events;

  /// Callback fired when the user taps a day cell.
  final ValueChanged<DateTime> onTapDate;

  /// Callback fired when the user swipes to a different month.
  final ValueChanged<int> onMonthChange;

  /// Optional configuration overrides.
  final MonthGridConfig config;

  const MonthGrid({
    super.key,
    required this.selectedDate,
    required this.monthOffset,
    required this.events,
    required this.onTapDate,
    required this.onMonthChange,
    this.config = const MonthGridConfig(),
  });

  @override
  State<MonthGrid> createState() => _MonthGridState();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _MonthGridState extends State<MonthGrid> {
  /// The year/month we are currently rendering.
  late int _renderYear;
  late int _renderMonth;

  @override
  void initState() {
    super.initState();
    _updateRenderMonth();
  }

  @override
  void didUpdateWidget(covariant MonthGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monthOffset != widget.monthOffset) {
      _updateRenderMonth();
    }
  }

  /// Resolve the render year/month from the month offset.
  void _updateRenderMonth() {
    final now = DateTime.now();
    final target = DateTime(now.year, now.month + widget.monthOffset);
    _renderYear = target.year;
    _renderMonth = target.month;
  }

  // ---------------------------------------------------------------------------
  // Calendar math helpers
  // ---------------------------------------------------------------------------

  /// First day-of-week (1=Mon … 7=Sun) for the first of the render month.
  int _firstWeekday() {
    return DateTime(_renderYear, _renderMonth, 1).weekday;
  }

  /// Number of days in the render month.
  int _daysInMonth() {
    return DateTime(_renderYear, _renderMonth + 1, 0).day;
  }

  /// Build a Set<DateTime> of dates that have events for fast lookup.
  Set<DateTime> _eventDateSet() {
    final dates = <DateTime>{};
    for (final event in widget.events) {
      dates.add(DateTime(event.startTime.year, event.startTime.month,
          event.startTime.day));
    }
    return dates;
  }

  /// Map a date -> list of calendar colors for that date's events.
  Map<DateTime, List<Color>> _eventColorsMap() {
    final result = <DateTime, List<Color>>{};
    for (final event in widget.events) {
      final day = DateTime(event.startTime.year, event.startTime.month,
          event.startTime.day);
      final color = _colorForEvent(event);
      if (color == null) continue;
      result.putIfAbsent(day, () => []).add(color);
    }
    return result;
  }

  /// Derive a [Color] from an event's calendar color string.
  Color? _colorForEvent(FamilyEvent event) {
    if (event.color != null && event.color!.isNotEmpty) {
      return _tryParseColor(event.color!);
    }
    if (event.calendars.isNotEmpty) {
      final hash = event.calendars.join(',').hashCode.abs();
      return kDefaultCalendarColors[hash % kDefaultCalendarColors.length];
    }
    return null;
  }

  Color? _tryParseColor(String hex) {
    try {
      String clean = hex;
      if (clean.startsWith('#')) clean = clean.substring(1);
      if (clean.length == 6) clean = 'FF$clean';
      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Grid dimensions
  // ---------------------------------------------------------------------------

  int _totalCells() {
    return _firstWeekday() - 1 + _daysInMonth();
  }

  int _weekNumber(DateTime date) {
    final jan1 = DateTime(date.year, 1, 1);
    final days = ((date.difference(jan1).inHours / 24) + 1).floor();
    return ((days - date.weekday + 10) / 7).floor();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final eventDates = _eventDateSet();
    final eventColors = _eventColorsMap();
    final today = DateTime.now();
    final firstDow = _firstWeekday();
    final daysInMonth = _daysInMonth();
    final cfg = widget.config;

    final totalCells = firstDow - 1 + daysInMonth;

    // Determine width needed based on week numbers + 7 cells.
    double maxWidth = 0.0;
    {
      final weekStartDay = totalCells ~/ 7 + 1;
      final weekNum = _weekNumber(
          DateTime(_renderYear, _renderMonth, weekStartDay));
      maxWidth = 36.0 + cfg.cellSize * 7 + (cfg.gap * 6) + 8.0;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 100) {
              widget.onMonthChange(widget.monthOffset - 1);
            } else if (details.primaryVelocity! < -100) {
              widget.onMonthChange(widget.monthOffset + 1);
            }
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Month/Year header ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _navButton(
                        icon: Icons.chevron_left,
                        onPressed: () =>
                            widget.onMonthChange(widget.monthOffset - 1),
                      ),
                      Text(
                        '${_kMonthNames[_renderMonth - 1]} $_renderYear',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: constants.textPrimary),
                      ),
                      _navButton(
                        icon: Icons.chevron_right,
                        onPressed: () =>
                            widget.onMonthChange(widget.monthOffset + 1),
                      ),
                    ],
                  ),
                ),

                // ── Weekday headers ──
                Row(
                  children: List.generate(7, (col) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          _kWeekdayLabels[col],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: constants.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    );
                  }),
                ),

                const Divider(height: 1, thickness: 0.5),

                // ── Week rows ──
                Expanded(
                  child: Column(
                    children: _buildWeekRows(
                      eventDates: eventDates,
                      eventColors: eventColors,
                      today: today,
                      selectedDate: widget.selectedDate,
                      firstDow: firstDow,
                      daysInMonth: daysInMonth,
                      cfg: cfg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build week-by-week rows.
  List<Widget> _buildWeekRows({
    required Set<DateTime> eventDates,
    required Map<DateTime, List<Color>> eventColors,
    required DateTime today,
    required DateTime selectedDate,
    required int firstDow,
    required int daysInMonth,
    required MonthGridConfig cfg,
  }) {
    final totalCells = firstDow - 1 + daysInMonth;
    final weeks = <Widget>[];
    int weekNum = -1;

    for (int weekStart = 0; weekStart < totalCells; weekStart += 7) {
      final cells = <Widget>[];
      int startDayIndex = weekStart + 1;
      weekNum = _weekNumber(DateTime(_renderYear, _renderMonth,
          startDayIndex > daysInMonth ? 1 : startDayIndex));

      // Week number cell
      cells.add(
        SizedBox(
          width: 36,
          child: Center(
            child: Text(
              'W$weekNum',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: constants.textSecondary,
                    fontSize: 9,
                  ),
            ),
          ),
        ),
      );

      for (int cell = 0; cell < 7; cell++) {
        final index = weekStart + cell;
        if (index >= totalCells) break;

        int day;
        if (index < firstDow - 1) {
          // Previous month overflow
          final prevMonth = _renderMonth == 1 ? 12 : _renderMonth - 1;
          final prevYear = _renderMonth == 1 ? _renderYear - 1 : _renderYear;
          final daysPrev = DateTime(prevYear, prevMonth + 1, 0).day;
          day = daysPrev - (firstDow - 1 - index);
          cells.add(_prevDayCell(
            day,
            cfg,
            eventDates,
            eventColors,
          ));
        } else {
          day = index - firstDow + 2;
          final date = DateTime(_renderYear, _renderMonth, day);
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final hasEvents = eventDates.contains(date);
          final colors = eventColors[date] ?? [];
          cells.add(_dayCell(
            day,
            cfg,
            isToday: isToday,
            isSelected: isSelected,
            hasEvents: hasEvents,
            colors: colors,
          ));
        }
      }

      weeks.add(Row(mainAxisSize: MainAxisSize.min, children: cells));
    }

    return weeks;
  }

  Widget _prevDayCell(
    int day,
    MonthGridConfig cfg,
    Set<DateTime> eventDates,
    Map<DateTime, List<Color>> eventColors,
  ) {
    return Padding(
      padding: EdgeInsets.all(cfg.gap),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Text(
            '$day',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: constants.textSecondary.withOpacity(0.3),
                  fontSize: cfg.fontSize,
                ),
          ),
        ),
      ),
    );
  }

  Widget _dayCell(
    int day,
    MonthGridConfig cfg, {
    required bool isToday,
    required bool isSelected,
    required bool hasEvents,
    required List<Color> colors,
  }) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: cfg.fontSize,
          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
        );

    Color textColor;
    BoxDecoration? decoration;

    if (isSelected) {
      textColor = constants.background;
      decoration = BoxDecoration(
        color: constants.primary,
        borderRadius: BorderRadius.circular(6),
      );
    } else if (isToday) {
      textColor = constants.primary;
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: constants.primary, width: 1.5),
      );
    } else {
      textColor = constants.textPrimary;
    }

    return Padding(
      padding: EdgeInsets.all(cfg.gap),
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () {
            final selected = DateTime(_renderYear, _renderMonth, day);
            widget.onTapDate(selected);
          },
          child: Container(
            decoration: decoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day', style: baseStyle?.copyWith(color: textColor)),
                if (hasEvents && colors.isNotEmpty) ...[
                  SizedBox(height: 2),
                  SizedBox(
                    height: cfg.dotRadius * 2 + 2,
                    width: cfg.maxDots * (cfg.dotRadius * 2 + 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          colors.take(cfg.maxDots).map((color) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 1.5),
                          child: CircleAvatar(
                            radius: cfg.dotRadius,
                            backgroundColor: color,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: constants.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 18, color: constants.textPrimary),
        ),
      ),
    );
  }
}

/// A palette of calendar colors used when [FamilyEvent.color] is not set.
const List<Color> kDefaultCalendarColors = [
  Color(0xFFC5221F), // Red
  Color(0xFF039BE5), // Blue
  Color(0xFF8E24AA), // Purple
  Color(0xFFD50000), // Pink
  Color(0xFF33691E), // Green
  Color(0xFFF4511E), // Orange
  Color(0xFF689F38), // Light Green
  Color(0xFF546E7A), // Blue Grey
  Color(0xFF00ACC1), // Cyan
  Color(0xFFAD1457), // Deep Purple
  Color(0xFF1DE9B6), // Teal
  Color(0xFFF57F17), // Amber
];
