import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/const.dart';
import '../core/theme.dart';
import '../models/partials.dart';
import '../services/weather_service.dart';

/// Custom [StatefulWidget] that replicates a system-style status bar
/// with time (left), date (center), and weather (right).
///
/// The bar is semi-transparent and does not block touches – it renders
/// on top of page content via a [Positioned] / [Stack] layout.
class StatusBar extends ConsumerStatefulWidget {
  final VoidCallback? onTapCalendar;
  final VoidCallback? onTapTasks;
  final VoidCallback? onTapPhotos;

  const StatusBar({super.key, this.onTapCalendar, this.onTapTasks, this.onTapPhotos});

  @override
  ConsumerState<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends ConsumerState<StatusBar> {
  late Timer _timer;
  late DateTime _now;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _updateTime();

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    developer.log('StatusBar tick', name: 'StatusBar');
    setState(() {
      _now = DateTime.now();
      _initialised = true;
    });
  }

  String _formatTime(DateTime now) {
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _formatDate(DateTime now) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    return '$dayName, ${monthName} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherNotifierProvider);
    
    // Handle weather data display
    Widget weatherContent = _weatherPlaceholder();
    
    if (weatherAsync != null) {
      final weather = weatherAsync;
      if (weather != null) {
        weatherContent = _weatherContent(
          weatherCodeToIcon(weather.currentWeatherCode),
          weather.currentTemperature.round(),
        );
      }
    } else if (weatherAsync is AsyncError) {
      // In case of error, show placeholder
      weatherContent = _weatherPlaceholder();
    } else if (weatherAsync is AsyncLoading) {
      // While loading, show placeholder
      weatherContent = _weatherPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: _buildBar(weatherContent),
    );
  }

  Widget _buildBar(Widget weatherContent) {
    return SizedBox(
      height: statusBarHeight,
      child: Container(
        decoration: StatusShapeDecoration(
          radius: statusBarCornerRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              // ── Time (left) ─────────────────────────────
              Text(
                _initialised ? _formatTime(_now) : '--:--',
                style: AppTheme.darkTheme.textTheme.bodySmall
                    ?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
              ),

              const SizedBox(width: 16.0),

              // ── Date (center) ───────────────────────────
              Expanded(
                child: Text(
                  _initialised ? _formatDate(_now) : '',
                  textAlign: TextAlign.center,
                  style: AppTheme.darkTheme.textTheme.bodySmall
                      ?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(width: 16.0),

              // ── Weather (right) ─────────────────────────
              weatherContent,
            ],
          ),
        ),
      ),
    );
  }

  /// Placeholder displayed while weather data is loading.
  Widget _weatherPlaceholder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.cloud_outlined, size: 16.0, color: textPrimary),
        SizedBox(width: 4.0),
        Text(
          '--°',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  /// Weather icon + temperature row.
  Widget _weatherContent(String icon, int temp) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(width: 4.0),
        Text(
          '$temp°',
          style: AppTheme.darkTheme.textTheme.bodySmall
              ?.copyWith(color: textPrimary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}