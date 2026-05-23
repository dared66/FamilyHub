part of 'partials.dart';

/// Parsed weather data from Open-Meteo API.
class WeatherData {
  /// Current temperature in Celsius.
  final double currentTemperature;

  /// Current wind speed in km/h.
  final double currentWindSpeed;

  /// Current WMO weather code.
  final int currentWeatherCode;

  /// Daily maximum temperature for the forecast day.
  final double dailyMaxTemperature;

  /// Daily minimum temperature for the forecast day.
  final double dailyMinTemperature;

  /// Daily WMO weather code.
  final int dailyWeatherCode;

  /// ISO date string of the forecast.
  final String date;

  const WeatherData({
    required this.currentTemperature,
    required this.currentWindSpeed,
    required this.currentWeatherCode,
    required this.dailyMaxTemperature,
    required this.dailyMinTemperature,
    required this.dailyWeatherCode,
    required this.date,
  });

  /// Checks whether it is currently cold (below 10°C).
  bool get isCold => currentTemperature < 10.0;

  /// Checks whether it is currently warm (25°C or above).
  bool get isWarm => currentTemperature >= 25.0;

  /// Checks whether it is raining or snowy based on weather code.
  bool get isPrecipitation => _precipitationCodes.contains(currentWeatherCode);

  static const _precipitationCodes = {
    45, 48, // Fog with rime frosting (technically non-precip)
    51, 53, 55, // Drizzle: light, moderate, dense
    56, 57, // Freezing drizzle: light, dense
    61, 63, 65, // Rain: slight, moderate, heavy
    66, 67, // Freezing rain: slight, heavy
    71, 73, 75, // Snow fall: slight, moderate, heavy
    77, // Snow grains
    80, 81, 82, // Rain showers: slight, moderate, violent
    85, 86, // Snow showers: slight, heavy
    95, 96, 99, // Thunderstorm
  };

  /// Human-readable description of the current weather condition.
  String get currentCondition => _weatherCodeDescription(currentWeatherCode);

  /// Human-readable description of the daily weather condition.
  String get dailyCondition => _weatherCodeDescription(dailyWeatherCode);

  static String _weatherCodeDescription(int code) {
    return switch (code) {
      0 => 'Clear sky',
      1 => 'Mainly clear',
      2 => 'Partly cloudy',
      3 => 'Overcast',
      45 => 'Foggy',
      48 => 'Depositing rime fog',
      51 => 'Light drizzle',
      53 => 'Moderate drizzle',
      55 => 'Dense drizzle',
      56 => 'Light freezing drizzle',
      57 => 'Dense freezing drizzle',
      61 => 'Slight rain',
      63 => 'Moderate rain',
      65 => 'Heavy rain',
      66 => 'Slight freezing rain',
      67 => 'Heavy freezing rain',
      71 => 'Slight snow fall',
      73 => 'Moderate snow fall',
      75 => 'Heavy snow fall',
      77 => 'Snow grains',
      80 => 'Slight rain showers',
      81 => 'Moderate rain showers',
      82 => 'Violent rain showers',
      85 => 'Slight snow showers',
      86 => 'Heavy snow showers',
      95 => 'Thunderstorm',
      96 => 'Thunderstorm with slight hail',
      99 => 'Thunderstorm with heavy hail',
      _ => 'Unknown',
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherData &&
          runtimeType == other.runtimeType &&
          currentTemperature == other.currentTemperature &&
          currentWindSpeed == other.currentWindSpeed &&
          currentWeatherCode == other.currentWeatherCode &&
          dailyMaxTemperature == other.dailyMaxTemperature &&
          dailyMinTemperature == other.dailyMinTemperature &&
          dailyWeatherCode == other.dailyWeatherCode &&
          date == other.date;

  @override
  int get hashCode =>
      currentTemperature.hashCode ^
      currentWindSpeed.hashCode ^
      currentWeatherCode.hashCode ^
      dailyMaxTemperature.hashCode ^
      dailyMinTemperature.hashCode ^
      dailyWeatherCode.hashCode ^
      date.hashCode;

  @override
  String toString() =>
      'WeatherData(temp: ${currentTemperature.round()}°C, max: ${dailyMaxTemperature.round()}°C, min: ${dailyMinTemperature.round()}°C, condition: $currentCondition)';
}
