import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('dbf843806a8968915c0f6794ef3d9914');

  Future<Weather> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    return await _weatherService.getWeather(cityName);
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/partly_cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/partly_shower.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: FutureBuilder<Weather>(
        future: _fetchWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;
            return Center(
              child: WeatherDisplay(
                weather: weather,
                getWeatherAnimation: getWeatherAnimation,
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;
  final String Function(String?) getWeatherAnimation;

  const WeatherDisplay({
    required this.weather,
    required this.getWeatherAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Lottie.asset(getWeatherAnimation(weather.mainConditions)),
        Text(
          '${weather.temperature.round()}°C',
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          weather.mainConditions ?? "",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
