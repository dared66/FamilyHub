import 'package:flutter/material.dart';

import '../core/const.dart';
import '../core/theme.dart';
import '../models/partials.dart';

/// A compact, single-line event card used in the agenda / list views.
///
/// Displays a colored left bar, the event start time (or "All-day" for
/// all-day events), and the event title (truncated at two lines).
class EventCard extends StatelessWidget {
  /// The event to display.
  final FamilyEvent event;

  const EventCard({
    super.key,
    required this.event,
  });

  /// Default calendar accent color when the event has no color set.
  static const _defaultColor = primary;

  @override
  Widget build(BuildContext context) {
    final eventColor = _parseColor(event.color) ?? _defaultColor;
    final timeText =
        event.allDay ? 'All-day' : _formatTime(event.startTime);

    return Container(
      height: 48.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          // ── Colored left bar (4 px) ──────────────────
          Container(
            width: 4.0,
            decoration: BoxDecoration(
              color: eventColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(width: 10.0),

          // ── Time / "All-day" ─────────────────────────
          Text(
            timeText,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 11.0,
            ),
          ),
          const SizedBox(width: 12.0),

          // ── Title (truncated at 2 lines) ─────────────
          Expanded(
            child: Text(
              event.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── helpers ────────────────────────────────────────────────────────

  /// Attempts to parse a hex color string into a [Color].
  ///
  /// Accepted formats:
  ///   - "0xAARRGGBB"
  ///   - "#AARRGGBB"
  ///   - "#RRGGBB"  (alpha defaults to opaque)
  ///
  /// Returns [null] when the input is null or unparseable.
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    // Handle "0xAARRGGBB"
    if (colorString.startsWith('0x')) {
      final parsed = int.tryParse(colorString.substring(2), radix: 16);
      if (parsed != null) return Color(parsed);
    }

    // Handle "#AARRGGBB" or "#RRGGBB"
    if (colorString.startsWith('#')) {
      final hex = colorString.substring(1);
      int intColor;
      if (hex.length == 8) {
        intColor = int.parse(hex, radix: 16);
      } else if (hex.length == 6) {
        intColor = 0xFF000000 | int.parse(hex, radix: 16);
      } else {
        return null;
      }
      return Color(intColor);
    }

    return null;
  }

  /// Formats a [DateTime] as "HH:MM" (24-hour).
  String _formatTime(DateTime date) {
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
