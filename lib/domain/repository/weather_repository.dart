import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weater_app/models/weather_model.dart';
import 'package:weater_app/services/location_service.dart';

Future<WeatherResponse> fetchWeather(
  double latitude,
  double longitude,
  LocationService locationService,
) async {
  final apiKey = dotenv.env['API_KEY'];
  final uriString =
      "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$latitude%2C$longitude?unitGroup=metric&include=hours%2Ccurrent&key=$apiKey&contentType=json";
  final uri = Uri.parse(uriString);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    try {
      var model = WeatherResponse.fromJson(json);
      return model;
    } catch (e) {
      throw Exception('Failed to parse weather data: $e');
    }
  } else {
    throw Exception('Failed to fetch weather data: ${response.statusCode}');
  }
}
