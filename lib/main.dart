import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/custom_search_delegate.dart';
import 'package:weather_app/forecast_screen.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/weather_forecast_model.dart';

void main() async {
  await dotenv.load();
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeDataProvider(),
    child: const MyApp(),
  ));
}

class ThemeDataProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  set isDark(bool status) {
    _isDark = status;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeDataProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: state.isDark ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String location = 'Ghatkopar';
  bool isSearchBarActive = false;
  final String? apiKey = dotenv.env["WEATHER_API_KEY"];
  WeatherModel weather = WeatherModel();
  List<ForecastModel> forecast = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      () async {
        final x = await getWeather(cityName: location);
        weather = x.$1;
        forecast = x.$2;
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ThemeDataProvider>();

    final appBar = AppBar(
      title: const Text("Weather App"),
      actions: [
        Tooltip(
          message: "light/dark mode",
          child: Switch(
            value: state.isDark,
            onChanged: (newVal) {
              state.isDark = newVal;
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          iconSize: 32,
          onPressed: () async {
            final res = await showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
            setState(() {
              isLoading = true;
              location = res ?? 'Ghatkopar';
              () async {
                final x = await getWeather(cityName: location);
                weather = x.$1;
                forecast = x.$2;
              }();
            });
          },
        ),
      ],
    );

    final header = Container(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${weather.tempratureInCelcius}°C/${weather.tempratureInFahrenheit}°F",
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
          ],
        ),
      ),
    );
    final lastUpdateDate =
        "${weather.lastUpdated?.year}-${weather.lastUpdated?.month}-${weather.lastUpdated?.day}";

    final footer = Column(
      children: [
        Text(weather.region ?? "undefined"),
        Text(weather.country ?? "undefined"),
        Text("Last Updated: $lastUpdateDate"),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 0,
                ),
                child: const LinearProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.7,
                          child: Card(
                            elevation: 6,
                            color: theme.colorScheme.primaryContainer,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    header,
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Image.network(
                                        "http:${weather.weatherIcon}",
                                        semanticLabel: weather.condition,
                                        scale: .3,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    footer,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "5-days Forecast",
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (int i = 0; i < forecast.length; i++)
                          ForecastItem(forecast: forecast[i]),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<(WeatherModel, List<ForecastModel>)> getWeather(
      {String cityName = "Mumbai"}) async {
    final url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=5&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(url));
    final weather = await jsonDecode(response.body);
    final weatherModel = WeatherModel.fromJson(weather);
    final forecast = ForecastModel.getForecastList(weather['forecast']);

    setState(() {
      isLoading = false;
    });
    return (weatherModel, forecast);
  }
}

class ForecastItem extends StatelessWidget {
  final ForecastModel forecast;
  const ForecastItem({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forecast.status!,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(forecast.date!),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "http:${forecast.weatherIcon!}",
              ),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.right_chevron),
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ForecastScreen(forecast: forecast),
          ),
        );
      },
    );
  }
}
