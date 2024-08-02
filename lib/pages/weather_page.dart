import 'package:firstie/models/weather_model.dart';
import 'package:firstie/servies/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('5455e5dca95a6b25cc319a6907f1717b');
  Weather? _weather;

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetch the weather
    _fetchWeather();
  }

  //fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    //weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any errors
    catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/windy.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorms':
        return 'asstes/storm.json';
      case 'clear':
        return 'assets/windy.json';
      default:
        return 'assets/windy.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "Loading City"),
            //animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temperature
            Text("${_weather?.temperature.round()}°C"),
            Text(_weather?.mainCondition ?? "Loading Weather Condition"),
          ],
        ),
      ),
    );
  }
}
