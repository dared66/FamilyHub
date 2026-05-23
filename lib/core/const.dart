/// Application-wide constants.

import 'dart:ui';

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Color constants
// ---------------------------------------------------------------------------

/// Deep dark background (#121212).
const Color background = Color(0xFFF5F5F5);

/// Surface / card background (#1E1E1E).
const Color surface = Color(0xFFFFFFFF);

/// Primary / accent blue (#1A73E8).
const Color primary = Color(0xFF1A73E8);

/// Success green (#34A853).
const Color success = Color(0xFF34A853);

/// Warning / danger red (#EA4335).
const Color danger = Color(0xFFEA4335);

/// Primary text color (white).
const Color textPrimary = Color(0xFF202124);

/// Secondary / muted text color.
const Color textSecondary = Color(0xFF5F6368);

/// Icon color.
const Color iconColor = Color(0xFF202124);

// ---------------------------------------------------------------------------
// API & configuration constants
// ---------------------------------------------------------------------------

/// Default timezone for weather queries.
const String defaultTimezone = 'America/Los_Angeles';

/// Cache TTL for weather data (2 hours).
const Duration weatherCacheDuration = Duration(hours: 2);

/// Watch refresh interval (30 minutes).
const Duration weatherRefreshInterval = Duration(minutes: 30);

/// Open-Meteo API base URL.
const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1/forecast';

/// Google Calendar API base URL.
const String calendarApiBase = 'https://www.googleapis.com/calendar/v3/';

/// Google Tasks API base URL.
const String tasksApiBase = 'https://www.googleapis.com/tasks/v1/';

/// Google Photos Library API base URL.
const String photosApiBase = 'https://www.googleapis.com/photoslibrary/v1/';

/// Package name.
const String packageName = 'io.familyhub.app';

/// Seattle coordinates (default hub location).
const double latitude = 47.6062;
const double longitude = -122.3321;

/// Polling intervals.
const Duration calendarPollInterval = Duration(minutes: 5);
const Duration tasksPollInterval = Duration(seconds: 60);
const Duration weatherPollInterval = Duration(minutes: 30);
const Duration photosPollInterval = Duration(hours: 24);

/// Cache TTLs.
const Duration photosCacheTTL = Duration(days: 7);
const Duration weatherCacheTTL = Duration(hours: 2);

/// Slideshow settings.
const Duration slideshowInterval = Duration(seconds: 8);
const Duration crossFadeDuration = Duration(milliseconds: 400);

/// UI constants.
const double topBarHeight = 32.0;

/// Height of the custom status bar.
const double statusBarHeight = 32.0;

/// Status bar corner radius.
const double statusBarCornerRadius = 12.0;
const double pageDotDiameter = 8.0;
const double pageDotSpacing = 12.0;

/// Page-dot active indicator color.
const Color pageDotActive = Color(0xFF1A73E8);

/// Page-dot inactive indicator color.
const Color pageDotInactive = Color(0xFF606060);
const double addSheetHeightRatio = 0.6;

/// Google Calendar scopes.
const List<String> googleCalendarScopes = ['https://www.googleapis.com/auth/calendar'];

/// Google Tasks scopes.
const List<String> googleTasksScopes = ['https://www.googleapis.com/auth/tasks'];

/// Google Photos scopes.
const List<String> googlePhotosScopes = ['https://www.googleapis.com/auth/photoslibrary.readonly'];

/// Default Google auth scopes.
const List<String> googleScopes = [
  'email',
  'openid',
  'https://www.googleapis.com/auth/calendar',
  'https://www.googleapis.com/auth/tasks',
  'https://www.googleapis.com/auth/photoslibrary.readonly',
];

// ---------------------------------------------------------------------------
// Custom shape decoration for the status bar
// ---------------------------------------------------------------------------

/// A [BoxShapeDecoration] with rounded corners used for the status bar.
class StatusShapeDecoration extends Decoration {
  final double radius;

  const StatusShapeDecoration({this.radius = 12.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _StatusBoxPainter(radius: radius);
  }
}

class _StatusBoxPainter extends BoxPainter {
  final double radius;

  const _StatusBoxPainter({required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = offset & cfg.size!;
    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius),
    );
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.black.withOpacity(0.5);
    canvas.drawRRect(rRect, paint);
  }
}

// ---------------------------------------------------------------------------
// WMO Weather-Code to emoji mapping
// ---------------------------------------------------------------------------

/// Maps a WMO weather code to an emoji icon for display.
String weatherCodeToIcon(int code) {
  if (code >= 45 && code <= 48) return '🌫️';
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return '🌧️';
  if ([56, 57, 66, 67].contains(code)) return '🌨️';
  if ([71, 73, 75, 77, 85, 86].contains(code)) return '❄️';
  if ([95, 96, 99].contains(code)) return '⛈️';
  return switch (code) {
    0 => '☀️',
    1 => '🌤️',
    2 => '⛅',
    3 => '☁️',
    _ => '🌡️',
  };
}
