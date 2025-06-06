import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weater_app/core/constants/colors.dart';
import 'package:weater_app/domain/repository/weather_repository.dart';
import 'package:weater_app/models/weather_model.dart';
import 'package:weater_app/services/location_service.dart';
import 'package:weater_app/utils/weather_icon_mapper.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late Future<WeatherResponse> futureWeather;
  final _locationService = LocationService();
  String _city = "Loading location...";

  @override
  void initState() {
    super.initState();
    _initWeather();
  }

  void _initWeather() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      final city = await _locationService.getCityFromPosition(position);
      setState(() => _city = city);
      futureWeather = fetchWeather(
        position.latitude,
        position.longitude,
        _locationService,
      );
    } else {
      futureWeather = Future.error("Weather not available");
      setState(() => _city = "Location unavailable");
    }
  }

  LinearGradient _getBackgroundGradient() {
    final hour = DateTime.now().hour;
    if (hour >= 23 || hour < 5) {
      return const LinearGradient(
        colors: [AppColors.nightBottom, AppColors.nightTop],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    } else if (hour >= 5 && hour < 12) {
      return const LinearGradient(
        colors: [AppColors.morningBottom, AppColors.morningTop],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    } else if (hour >= 12 && hour < 16) {
      return const LinearGradient(
        colors: [AppColors.afternoonBottom, AppColors.afternoonTop],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    } else {
      return const LinearGradient(
        colors: [AppColors.eveningBottom, AppColors.eveningTop],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    }
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
                style: const TextStyle(color: Colors.black),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final weather = snapshot.data!;
          final currentTemp =
              weather.currentConditions?.temp?.toStringAsFixed(1) ??
              weather.days?.first.hours?.first.temp?.toStringAsFixed(1) ??
              'N/A';

          return Container(
            decoration: BoxDecoration(gradient: _getBackgroundGradient()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: WeatherHeader(city: _city),
                ),
                SizedBox(
                  height: 180,
                  child: SvgPicture.asset(
                    getWeatherIconAsset(
                      weather.currentConditions?.icon ?? 'default',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "$currentTemp°",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 76,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                HourlyWeatherList(hours: weather.days?.first.hours ?? []),
                const SizedBox(height: 7),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WeatherHeader extends StatelessWidget {
  final String city;

  const WeatherHeader({required this.city, super.key});

  String getDate() => DateFormat('MMMMEEEEd').format(DateTime.now());
  String getTime() => DateFormat('HH:mm').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 200)),
      builder:
          (_, __) => Column(
            children: [
              const SizedBox(height: 80),
              Text(
                getDate(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
              Text(
                getTime(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                city,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
    );
  }
}

class HourlyWeatherList extends StatelessWidget {
  final List<Hours> hours;

  const HourlyWeatherList({required this.hours, super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: SizedBox(
                        height: 40,
                        child: SvgPicture.asset(
                          getWeatherIconAsset(hour.icon ?? 'default'),
                        ),
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
