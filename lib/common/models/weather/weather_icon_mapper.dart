class WeatherIconMapper {
  static final Map<String, String> _openWeatherMapIcons = {
    "01d": "assets/weather_icons/clear-day.svg",
    "01n": "assets/weather_icons/clear-night.svg",
    "02d": "assets/weather_icons/partly-cloudy-day.svg",
    "02n": "assets/weather_icons/partly-cloudy-night.svg",
    "03d": "assets/weather_icons/cloudy.svg",
    "03n": "assets/weather_icons/cloudy.svg",
    "04d": "assets/weather_icons/cloudy.svg",
    "04n": "assets/weather_icons/cloudy.svg",
    "09d": "assets/weather_icons/rain.svg",
    "09n": "assets/weather_icons/rain.svg",
    "10d": "assets/weather_icons/partly-cloudy-day-rain.svg",
    "10n": "assets/weather_icons/partly-cloudy-night-rain.svg",
    "11d": "assets/weather_icons/thunderstorms.svg",
    "11n": "assets/weather_icons/thunderstorms.svg",
    "13d": "assets/weather_icons/partly-cloudy-day-snow.svg",
    "13n": "assets/weather_icons/partly-cloudy-night-snow.svg",
    "50d": "assets/weather_icons/mist.svg",
    "50n": "assets/weather_icons/mist.svg",
  };

  static String getIconPath(String iconCode) {
    return _openWeatherMapIcons[iconCode] ?? "assets/weather_icons/default.svg";
  }
}
