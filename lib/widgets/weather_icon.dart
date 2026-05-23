import 'package:flutter/material.dart';

/// Weather icon pill — emoji + high/low temperature.
class WeatherIcon extends StatelessWidget {
  final String type; // 'sunny', 'cloudy', 'rainy', 'snowy', 'partly-cloudy'
  final int high;
  final int low;

  const WeatherIcon({
    super.key,
    required this.type,
    required this.high,
    required this.low,
  });

  static const _emojis = {
    'sunny': '☀️',
    'cloudy': '☁️',
    'rainy': '🌧️',
    'snowy': '❄️',
    'partly-cloudy': '⛅',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_emojis[type] ?? '☀️', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$high° / $low°',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.9) ?? Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
