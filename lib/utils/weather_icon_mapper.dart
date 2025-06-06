
String getWeatherIconAsset(String iconName) {
  switch (iconName) {
    case 'clear-day':
      return 'assets/images/sunny.svg';
    case 'clear-night':
      return 'assets/images/clear_night.svg';
    case 'partly-cloudy-day':
      return 'assets/images/partly_cloudy_day.svg';
    case 'partly-cloudy-night':
      return 'assets/images/partly_cloudy_night.svg';
    case 'cloudy':
      return 'assets/images/cloudy.svg';
    case 'rain':
    case 'showers-day':
    case 'showers-night':
      return 'assets/images/rain.svg';
    case 'snow':
      return 'assets/images/snow.svg';
    case 'wind':
      return 'assets/images/wind.svg';
    case 'fog':
      return 'assets/images/fog.svg';
    case 'thunderstorm-day':
    case 'thunderstorm-night':
      return 'assets/images/thunderstorm.svg';
    default:
      return 'assets/images/default.svg'; // fallback icon
  }
}
