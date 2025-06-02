import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weater_app/models/weather_model.dart';

// Change return type to WeatherResponse
Future<WeatherResponse> fetchWeather() async {
  final uri = Uri.parse(
    'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/51.7896%2C19.4589?unitGroup=metric&include=hours%2Ccurrent&key=NCKX6NKQJSK633Y8GVAP36BYP&contentType=json',
  );

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    
    try {
      // Parse as WeatherResponse, not Hours
      var model = WeatherResponse.fromJson(json);
      return model;
    } catch (e) {
      throw Exception('Failed to parse weather data: $e');
    }
  } else {


    throw Exception('Failed to fetch weather data: ${response.statusCode}');
  }
}