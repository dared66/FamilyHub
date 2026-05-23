import 'package:flutter/material.dart';
import '../models/partials.dart';
import '../core/theme.dart';
import '../core/const.dart';

/// Weather strip showing current conditions + today's high/low.
class WeatherStrip extends StatelessWidget {
  final WeatherData weather;

  const WeatherStrip({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Text(
            _weatherCodeToEmoji(weather.currentWeatherCode),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.currentTemperature.toInt()}°C',
                style: AppTheme.darkTheme.textTheme.titleLarge
                    ?.copyWith(color: textPrimary),
              ),
              Text(
                weather.currentCondition,
                style: AppTheme.darkTheme.textTheme.bodySmall
                    ?.copyWith(color: textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'H: ${weather.dailyMaxTemperature.toInt()}°',
                style: AppTheme.darkTheme.textTheme.bodySmall
                    ?.copyWith(color: textPrimary),
              ),
              Text(
                'L: ${weather.dailyMinTemperature.toInt()}°',
                style: AppTheme.darkTheme.textTheme.bodySmall
                    ?.copyWith(color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weatherCodeToEmoji(int code) {
    switch (code) {
      case 0: return '☀️';
      case 1: return '🌤️';
      case 2: return '⛅';
      case 3: return '☁️';
      case 45:
      case 48: return '🌫️';
      case 51:
      case 53:
      case 55: return '🌦️';
      case 61:
      case 63:
      case 65: return '🌧️';
      case 71:
      case 73:
      case 75: return '🌨️';
      case 80:
      case 81:
      case 82: return '🌧️';
      case 95: return '⛈️';
      case 96:
      case 99: return '⛈️';
      default: return '🌡️';
    }
  }
}
