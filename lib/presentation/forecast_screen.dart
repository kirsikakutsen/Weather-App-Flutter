import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weater_app/core/constants/colors.dart';
import 'package:weater_app/domain/repository/weather_repository.dart';
import 'package:weater_app/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:weater_app/services/location_service.dart'; // NEW

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late Future<WeatherResponse> futureWeather;
  final LocationService _locationService = LocationService();

  String _city = "Loading location...";

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();

    _locationService.getCurrentPosition().then((position) async {
      if (position != null) {
        final city = await _locationService.getCityFromPosition(position);
        setState(() {
          _city = city;
        });
      } else {
        setState(() {
          _city = "Location unavailable";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherResponse>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            final currentTemp =
                weather.currentConditions?.temp?.toStringAsFixed(1) ??
                weather.days?.first.hours?.first.temp?.toStringAsFixed(1) ??
                'N/A';
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
                    child: SvgPicture.asset(
                      "assets/images/ic_cloudy.svg",
                      width: 250,
                    ),
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
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 200)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final formattedDate = DateFormat('MMMMEEEEd').format(now);
        final formattedTime = DateFormat('HH:mm').format(now);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Text(
                formattedDate,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20),
              ),
            ),
            Text(
              formattedTime,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 52,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _city,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 20),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHourlyWeather(List<Hours> hours) {
    return Column(
      children: [
        const Text(
          "Today",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 20),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Divider(
            color: AppColors.textPrimary,
            thickness: 1,
            height: 34,
          ),
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
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        "assets/images/ic_cloudy.svg",
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
