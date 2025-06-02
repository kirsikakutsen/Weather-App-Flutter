import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weater_app/core/constants/colors.dart';
import 'package:weater_app/domain/repository/weather_repository.dart';
import 'package:weater_app/models/weather_model.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late Future<WeatherResponse> futureWeather; // Changed type

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherResponse>( // Changed type
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}', 
                style: const TextStyle(color: Colors.white)
              )
            );
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            
            // Get current temperature from currentConditions or first hour
            final currentTemp = weather.currentConditions?.temp?.toStringAsFixed(1) ?? 
                              weather.days?.first.hours?.first.temp?.toStringAsFixed(1) ?? 
                              'N/A';
            
            // Get hourly data from first day
            final hourly = weather.days?.first.hours?.toList() ?? [];

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: [0.0, 0.8],
                  colors: [Color(0xFFE5A28C), Color(0xFF5EABCA)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeLocationDate(),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SvgPicture.asset("assets/images/ic_cloudy.svg", width: 250),
                  ),
                  Text(
                    "$currentTemp°",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 76,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildHourlyWeather(hourly),
                  const SizedBox(height: 7),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Widget _buildTimeLocationDate() {
    final time = DateTime.now();
    final formattedTime = DateFormat("HH:mm").format(time);
    final formattedDate = DateFormat.yMMMMd().format(time);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 80.0),
          child: Text(formattedDate, style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
        ),
        Text(formattedTime, style: TextStyle(color: AppColors.textPrimary, fontSize: 52, fontWeight: FontWeight.bold)),
        const Text("Łódź, Poland", style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
      ],
    );
  }

  Widget _buildHourlyWeather(List<Hours> hours) {
    return Column(
      children: [
        const Text("Today", style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Divider(color: AppColors.textPrimary, thickness: 1, height: 34),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final hour = hours[index];
              return SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hour.datetime?.substring(0, 5) ?? "--:--",
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        "assets/images/ic_cloudy.svg", // Optional: map conditions to icons
                        width: 40,
                      ),
                    ),
                    Text(
                      "${hour.temp?.toStringAsFixed(0) ?? "--"}°",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}