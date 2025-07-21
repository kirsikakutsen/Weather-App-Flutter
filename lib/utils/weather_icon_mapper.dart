String getWeatherIconAsset(String? icon) {
  switch (icon) {
    case "snow":
    case "snow-showers-day":
    case "snow-showers-night":
      return "assets/images/snow.svg";
    case "rain":
    case "showers-day":
    case "showers-night":
      return "assets/images/rain.svg";
    case "fog":
      return "assets/images/fog.svg";
    case "wind":
      return "assets/images/wind.svg";
    case "cloudy":
      return "assets/images/cloudy.svg";
    case "partly-cloudy-day":
      return "assets/images/partly_cloudy_day.svg";
    case "partly-cloudy-night":
      return "assets/images/partly_cloudy_night.svg";
    case "clear-day":
      return "assets/images/sunny.svg";
    case "clear-night":
      return "assets/images/clear_night.svg";
    case "thunder-rain":
    case "thunder-showers-day":
    case "thunder-showers-night":
      return "assets/images/thunder_rain.svg";
    default:
      return "assets/images/default.svg";
  }
}
