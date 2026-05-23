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

  List<WeatherData> fetchWeekForecast() {
    // Generate 7 days of fake weather data with realistic patterns
    List<WeatherData> forecast = [];
    // WMO codes for weather conditions: 2=Cloudy, 3=Rain, 61=Light Rain, 80=Light Shower, 0=Clear, 1=Partly Cloudy, 2=Cloudy
    List<int> wmoCodes = [2, 3, 61, 80, 0, 1, 2];
    List<String> weatherEmojis = ['☁️', '🌧️', '🌦️', '💧', '☀️', '⛅', '☁️'];
    
    for (int i = 0; i < 7; i++) {
      // Calculate temperature range with variation
      double maxTemp = 65.0 + (i * 2.0); // Gradually increasing max temp
      double minTemp = 45.0 + (i * 1.0); // Gradually increasing min temp
      maxTemp = maxTemp.clamp(65.0, 79.0);
      minTemp = minTemp.clamp(45.0, 54.0);
      
      // Create date string for current day plus i days
      String date = DateTime.now().add(Duration(days: i)).toIso8601String().split('T').first;
      
      forecast.add(WeatherData(
        currentTemperature: 55.0 + i * 1.5,
        currentWindSpeed: 8.5 + i * 0.5,
        currentWeatherCode: wmoCodes[i],
        dailyMaxTemperature: maxTemp,
        dailyMinTemperature: minTemp,
        dailyWeatherCode: wmoCodes[i],
        date: date,
      ));
    }
    
    return forecast;
  }
}

final weatherServiceProvider = Provider<WeatherService>((ref) => WeatherService());

final weekForecastProvider = Provider<List<WeatherData>>((ref) {
  return ref.read(weatherServiceProvider).fetchWeekForecast();
});

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