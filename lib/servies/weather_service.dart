import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/forecast";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return Weather.fromJson(jsonResponse);
      } catch (e) {
        print('Error parsing weather data: $e');
        throw Exception('Error parsing weather data: $e');
      }
    } else {
      throw Exception('Error');
    }
  }

  Future<String> getCurrentCity() async {
    //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //convert the location into list of placemark object
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality ?? 'Unknown Location';
    } else {
      return 'Unknown Location';
    }
    // //extract the cityname from the first placemark
    // String? city = placemarks[0].locality;
    // return city ?? "";
  }
}
