import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/partials.dart';
import '../core/const.dart';

/// Mock WeatherService — returns fake Seattle weather immediately.
class WeatherService {
  WeatherData fetchWeather() {
    return WeatherData(
      currentTemperature: 55.0,
      currentWindSpeed: 8.5,
      currentWeatherCode: 2,
      dailyMaxTemperature: 62.0,
      dailyMinTemperature: 48.0,
      dailyWeatherCode: 3,
      date: DateTime.now().toIso8601String(),
    );
  }
}

final weatherServiceProvider = Provider<WeatherService>((ref) => WeatherService());

class WeatherNotifier extends Notifier<WeatherData?> {
  @override
  WeatherData? build() {
    _fetch();
    return null;
  }

  void refresh() {
    state = null;
    _fetch();
  }

  void _fetch() {
    try {
      state = ref.read(weatherServiceProvider).fetchWeather();
    } catch (_) {
      state = WeatherData(
        currentTemperature: 55.0,
        currentWindSpeed: 8.5,
        currentWeatherCode: 2,
        dailyMaxTemperature: 62.0,
        dailyMinTemperature: 48.0,
        dailyWeatherCode: 3,
        date: DateTime.now().toIso8601String(),
      );
    }
  }
}

final weatherNotifierProvider = NotifierProvider<WeatherNotifier, WeatherData?>(
  WeatherNotifier.new,
);