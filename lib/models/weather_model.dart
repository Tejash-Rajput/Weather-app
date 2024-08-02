class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['city']?['name'] ?? 'Unknown City',
      temperature: json['list'][0]['main']['temp']?.toDouble() ?? 0.0,
      mainCondition: json['list'][0]['weather'] != null &&
              json['list'][0]['weather'].isNotEmpty
          ? json['list'][0]['weather'][0]['main'] ?? 'Unknown'
          : 'Unknown',
    );
  }
}
