class ForecastModel {
  final double? maxTempInCelsius;
  final double? maxTempInFahrenheit;
  final double? minTempInCelsius;
  final double? minTempInFahrenheit;
  final double? avgTempInCelsius;
  final double? avgTempInFahrenheit;
  final String? weatherIcon;
  final String? status;
  final String? date;

  const ForecastModel({
    required this.maxTempInCelsius,
    required this.avgTempInFahrenheit,
    required this.avgTempInCelsius,
    required this.minTempInFahrenheit,
    required this.minTempInCelsius,
    required this.maxTempInFahrenheit,
    required this.weatherIcon,
    required this.status,
    required this.date,
  });

  factory ForecastModel.fromJson(dynamic json) {
    return ForecastModel(
      minTempInCelsius: json["day"]["mintemp_c"],
      minTempInFahrenheit: json['day']['mintemp_f'],
      maxTempInCelsius: json["day"]["maxtemp_c"],
      maxTempInFahrenheit: json['day']['maxtemp_f'],
      avgTempInCelsius: json["day"]["avgtemp_c"],
      avgTempInFahrenheit: json['day']['avgtemp_f'],
      status: json['day']['condition']['text'],
      weatherIcon: json['day']['condition']['icon'],
      date: json["date"],
    );
  }

  static List<ForecastModel> getForecastList(dynamic json, {int day = 5}) {
    return json["forecastday"].map<ForecastModel>((e) {
      return ForecastModel.fromJson(e);
    }).toList();
  }

  @override
  String toString() {
    return """
      Minimum temprature in Celsius: $minTempInCelsius,
      Minimum temprature in Farenheit: $minTempInFahrenheit,
      Maximum temprature in Celsius: $maxTempInCelsius,
      Maximum temprature in Fahrenheit: $maxTempInFahrenheit,
      Average temprature in Celsius: $avgTempInCelsius,
      Average temprature in Fahrenheit: $avgTempInFahrenheit,
      date: $date,
    """;
  }
}
