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

LinearGradient _getBackgroundGradient(double tzOffset) {
  DateTime locationTime = DateTime.now().toUtc().add(Duration(hours: tzOffset.toInt()));
  final hour = locationTime.hour;

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

class _ForecastScreenState extends State<ForecastScreen> {
  Future<WeatherResponse>? futureWeather;
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
      final weatherFuture = fetchWeather(
        position.latitude,
        position.longitude,
        _locationService,
      );

      setState(() {
        _city = city;
        futureWeather = weatherFuture;
      });
    } else {
      setState(() {
        _city = "Location unavailable";
        futureWeather = Future.error("Weather not available");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherResponse>(
        future: futureWeather,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              gradient:
                  (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData)
                      ? _getBackgroundGradient(snapshot.data?.tzoffset ?? 0.0)
                      : _getBackgroundGradient(0),
            ),
            child: _buildWeatherContent(snapshot),
          );
        },
      ),
    );
  }

  Widget _buildWeatherContent(AsyncSnapshot<WeatherResponse> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting ||
        futureWeather == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.textPrimary),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text(
          snapshot.error.toString(),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 20),
        ),
      );
    }

    final weather = snapshot.data!;
    final currentTemp =
        weather.currentConditions?.temp?.toStringAsFixed(0) ?? "--";

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: WeatherHeader(city: _city, tzOffset: weather.tzoffset ?? 0.0),
        ),
        SizedBox(
          height: 180,
          child: SvgPicture.asset(
            getWeatherIconAsset(weather.currentConditions?.icon),
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
    );
  }
}

class WeatherHeader extends StatelessWidget {
  final String city;
  final double tzOffset;

  const WeatherHeader({required this.city, required this.tzOffset, super.key});

  DateTime get locationTime {
    final utcNow = DateTime.now().toUtc();
    return utcNow.add(Duration(hours: tzOffset.toInt()));
  }
  
  String getDate() => DateFormat('MMMMEEEEd').format(locationTime);
  String getTime() => DateFormat('HH:mm').format(locationTime);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder:(_, __) => Column(
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
            itemBuilder: (context, index) => _hourlyWeatherListItemBuilder(context, index, hours),
          ),
        ),
      ],
    );
  }
}

_hourlyWeatherListItemBuilder(
    BuildContext context,
    int index,
    List<Hours> hours,
  ) {
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
  }
