class WeatherModel {
  final String? cityName;
  final String? region;
  final String? country;

  final double? tempratureInCelcius;
  final double? tempratureInFahrenheit;
  final String? condition;
  final String? weatherIcon;
  final DateTime? lastUpdated;

  WeatherModel({
    this.lastUpdated,
    this.weatherIcon,
    this.condition,
    this.tempratureInFahrenheit,
    this.tempratureInCelcius,
    this.country,
    this.region,
    this.cityName,
  });

  factory WeatherModel.fromJson(dynamic json) {
    return WeatherModel(
      cityName: json["location"]["name"],
      region: json["location"]["region"],
      country: json["location"]["country"],
      tempratureInCelcius: json["current"]["temp_c"],
      tempratureInFahrenheit: json["current"]["temp_f"],
      condition: json["current"]["condition"]["text"],
      weatherIcon: json["current"]["condition"]["icon"],
      lastUpdated: DateTime.parse(json["current"]["last_updated"]),
    );
  }

  @override
  String toString() {
    return """
      WeatherModel {
        lastUpdated: $lastUpdated,
        weatherIcon: $weatherIcon,
        condition: $condition,
        tempratureInFahrenheit: $tempratureInFahrenheit,
        tempratureInCelcius: $tempratureInCelcius,
        country: $country,
        region: $region,
        cityName: $cityName,
      }
    """;
  }
}
